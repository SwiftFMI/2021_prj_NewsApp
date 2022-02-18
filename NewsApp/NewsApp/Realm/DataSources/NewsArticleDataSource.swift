//
//  NewsArticleDataSource.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 18.02.22.
//

import Foundation
import RealmSwift

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
        
        delegate?.newsArticleDataSourceDeletage(willUpdateArticles: self)
        
        // currently it loads all articles saved locally
        articlesDb = getArticles()
        articles = articlesDb?.toArray()
        
        delegate?.newsArticleDataSourceDelegate(didUpdateArticles: self)
        
        if let articles = articlesDb {
            token = RealmHelper.observeResults(articles, actions: { [weak self] changes in
                if let self = self {
                    self.delegate?.newsArticleDataSourceDeletage(willUpdateArticles: self)
                    self.articlesDb = articles
                    self.articles = self.articlesDb?.toArray()
                    self.delegate?.newsArticleDataSourceDelegate(didUpdateArticles: self)
                }
            })
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
}

// MARK: Methods to sync local data with API
extension NewsArticleDataSource {
    /// Example sync of local articles with ones fetched from API, use similar one on things like pull to refresh, hard syncs, etc...
    /// Updates local articles and triggers NewsArticleDataSourceDelegate methods if the notification token is observing.
    func syncArticles(forCountry country: NewsCountry) {
        NewsAPISyncer().getTopHeadlines(country: country, completion: { articles in
            guard let realm = try? Realm() else {
                return
            }
            
            articles?.forEach { article in
                realm.safeWrite {
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
        })
    }
}

