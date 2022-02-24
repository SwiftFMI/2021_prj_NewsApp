//
//  NewsArticleDataSource.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 18.02.22.
//

import Foundation
import RealmSwift
import UIKit

protocol NewsArticleDataSourceDelegate: AnyObject {
    func newsArticleDataSourceDeletage(willUpdateArticles dataSource: NewsArticleDataSource)
    func newsArticleDataSourceDelegate(didUpdateArticles dataSource: NewsArticleDataSource)
}

class NewsArticleDataSource {
    private var articlesDb: Results<ArticleDB>?
    private var token: NotificationToken?
    
    private(set) var articles: [ArticleDB]?
    
    var currentPage: Int = 0
    
    weak var delegate: NewsArticleDataSourceDelegate?
    
    init(withMessageDataSourceDelegate delegate: NewsArticleDataSourceDelegate? = nil, loadOnInit: Bool = false) {
        self.delegate = delegate
        loadOnInit ? loadAllArticles() : nil
    }
    
    init(withArticleCategory category: NewsCategory, withMessageDataSourceDelegate delegate: NewsArticleDataSourceDelegate? = nil, loadOnInit: Bool = false) {
        self.delegate = delegate
        loadOnInit ? loadArticles(forCategory: category) : nil
    }
    
    init(withArticleSource source: NewsSource, withMessageDataSourceDelegate delegate: NewsArticleDataSourceDelegate? = nil, loadOnInit: Bool = false) {
        self.delegate = delegate
        loadOnInit ? loadArticles(forSource: source) : nil
    }
    
    deinit {
        token = nil
    }
    
    func loadAllArticles() {
        token = nil
        
        articlesDb = getArticles(sortOptions: [SortDescriptor(keyPath: "recommendationValue", ascending: false),
                                               SortDescriptor(keyPath: "publishedAt", ascending: false)])
        articles = articlesDb?.toArray()
        
        updateRecommendationValues(forArticles: articlesDb)
        
        delegate?.newsArticleDataSourceDelegate(didUpdateArticles: self)
        
        if let articles = articlesDb {
            token = setObserver(forArticles: articles)
        }
    }
    
    func loadFavouriteArticles() {
        token = nil
        
        articlesDb = getFavouriteArticles()
        articles = articlesDb?.toArray()
        
        delegate?.newsArticleDataSourceDelegate(didUpdateArticles: self)
        
        if let articles = articlesDb {
            token = setObserver(forArticles: articles)
        }
    }
    
    func loadArticles(forSource source: NewsSource) {
        token = nil
        
        articlesDb = getArticles(forSource: source)
        articles = articlesDb?.toArray()
        
        delegate?.newsArticleDataSourceDelegate(didUpdateArticles: self)
        
        if let articles = articlesDb {
            token = setObserver(forArticles: articles)
        }
    }
    
    func loadArticles(forCategory category: NewsCategory) {
        token = nil
        
        articlesDb = getArticles(forCategory: category)
        articles = articlesDb?.toArray()
        
        delegate?.newsArticleDataSourceDelegate(didUpdateArticles: self)
        
        if let articles = articlesDb {
            token = setObserver(forArticles: articles)
        }
    }
    
    func setObserver(forArticles articles: Results<ArticleDB>) -> NotificationToken? {
        RealmHelper.observeResults(articles, actions: { [weak self] changes in
            if let self = self {
                self.articlesDb = articles
                self.articles = self.articlesDb?.toArray()
                
                self.delegate?.newsArticleDataSourceDelegate(didUpdateArticles: self)
            }
        })
    }
    
    private func updateRecommendationValues(forArticles articles: Results<ArticleDB>?) {
        guard let realm = try? Realm(), let userInfo = UserInfoDataSource().userInfo else { return }
        
        realm.safeWrite {
            articles?.forEach { article in
                article.calculateRecommendationValue(forUserInfo: userInfo)
            }
        }
    }
}

// MARK: Methods to fetch articles from local data
extension NewsArticleDataSource {
    func getArticles(forPredicate predicate: NSPredicate? = nil, sortOptions: [RealmSwift.SortDescriptor]? = nil) -> Results<ArticleDB>? {
        guard let realm = try? Realm() else {
            return nil
        }
        
        let sort = sortOptions ?? [SortDescriptor(keyPath: "publishedAt", ascending: false)]
        
        guard let predicate = predicate else {
            return realm.objects(ArticleDB.self).sorted(by: sort)
        }
        
        return realm.objects(ArticleDB.self).filter(predicate).sorted(by: sort)
    }
    
    func getArticles(forCategory category: NewsCategory, sortOptions: [RealmSwift.SortDescriptor]? = nil) -> Results<ArticleDB>? {
        getArticles(forPredicate: NSPredicate(format: "category == %@", category.rawValue), sortOptions: sortOptions)
    }
    
    func getArticles(forSource source: NewsSource, sortOptions: [RealmSwift.SortDescriptor]? = nil) -> Results<ArticleDB>? {
        getArticles(forPredicate: NSPredicate(format: "source == %@", source.rawValue), sortOptions: sortOptions)
    }
    
    func getFavouriteArticles(sortOptions: [RealmSwift.SortDescriptor]? = nil) -> Results<ArticleDB>? {
        getArticles(forPredicate: NSPredicate(format: "favourite == true"), sortOptions: sortOptions)
    }
}

// MARK: Methods to save articles to local data
extension NewsArticleDataSource {
    func saveArticles(_ articles: [Article]?, fromCategory category: NewsCategory? = nil, fromSource source: NewsSource? = nil) {
        guard let realm = try? Realm(), let userInfo = UserInfoDataSource().userInfo else {
            return
        }
        
        realm.safeWrite {
            articles?.forEach { article in
                let articleDb = ArticleDB(author: article.author,
                                          title: article.title,
                                          articleDescription: article.description,
                                          url: article.url,
                                          urlToImage: article.urlToImage,
                                          publishedAt: article.publishedAt,
                                          content: article.content,
                                          category: category,
                                          source: source)
                
                articleDb.calculateRecommendationValue(forUserInfo: userInfo)
                
                realm.add(articleDb, update: .modified)
            }
        }
    }
}

// MARK: Methods to sync local data with API
extension NewsArticleDataSource {
    func syncArticles(forCountry country: NewsCountry, completion: (() -> Void?)? = nil) {
        delegate?.newsArticleDataSourceDeletage(willUpdateArticles: self)
        
        NewsAPISyncer().getTopHeadlines(country: country, page: currentPage + 1, completion: { [weak self] articles in
            self?.saveArticles(articles)
            self?.currentPage += 1
            completion?()
        })
    }
    
    func syncArticles(forCategory category: NewsCategory, completion: (() -> Void?)? = nil) {
        delegate?.newsArticleDataSourceDeletage(willUpdateArticles: self)
        
        NewsAPISyncer().getTopHeadlines(forCategory: category, page: currentPage + 1, completion: { [weak self] articles in
            self?.saveArticles(articles, fromCategory: category)
            self?.currentPage += 1
            completion?()
        })
    }
    
    func syncArticles(fromSource source: NewsSource, completion: (() -> Void?)? = nil) {
        delegate?.newsArticleDataSourceDeletage(willUpdateArticles: self)
        
        NewsAPISyncer().getTopHeadlines(forSource: source, page: currentPage + 1, completion: { [weak self] articles in
            self?.saveArticles(articles, fromSource: source)
            self?.currentPage += 1
            completion?()
        })
    }
}

