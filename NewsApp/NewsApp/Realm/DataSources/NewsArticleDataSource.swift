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
    
    weak var delegate: NewsArticleDataSourceDelegate?
    
    init(withMessageDataSourceDelegate delegate: NewsArticleDataSourceDelegate? = nil, loadOnInit: Bool = false) {
        self.delegate = delegate
        loadOnInit ? loadArticles() : nil
    }
    
    deinit {
        token = nil
    }
    
    func loadArticles() {
        token = nil
        
        // currently it loads all articles saved locally
        articlesDb = getArticles()
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
}

// MARK: Methods to save articles to local data
extension NewsArticleDataSource {
    func saveArticles(_ articles: [Article]?) {
        guard let realm = try? Realm() else {
            return
        }
        
        realm.safeWrite {
            articles?.forEach { article in
                realm.add(ArticleDB(author: article.author,
                                    title: article.title,
                                    articleDescription: article.description,
                                    url: article.url,
                                    urlToImage: article.urlToImage,
                                    publishedAt: article.publishedAt,
                                    content: article.content),
                          update: .modified
                )
            }
        }
    }
}

// MARK: Methods to sync local data with API
extension NewsArticleDataSource {
    func syncArticles(forCountry country: NewsCountry, completion: (() -> Void?)? = nil) {
        delegate?.newsArticleDataSourceDeletage(willUpdateArticles: self)
        
        NewsAPISyncer().getTopHeadlines(country: country, completion: { [weak self] articles in
            self?.saveArticles(articles)
            completion?()
        })
    }
}

