//
//  ArticleDB.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 17.02.22.
//

import Foundation
import RealmSwift

class ArticleDB: Object {
    @objc dynamic var id: String?
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var articleDescription: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: String?
    @objc dynamic var content: String?
    
    @objc dynamic var favourite: Bool = false
    
    @objc dynamic private var category: String?
    @objc dynamic private var source: String?
    
    @objc dynamic var recommendationValue: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(author: String? = nil, title: String? = nil, articleDescription: String? = nil, url: String? = nil, urlToImage: String? = nil, publishedAt: String? = nil, content: String? = nil, category: NewsCategory? = nil, source: NewsSource? = nil) {
        self.init()
        
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.category = category?.rawValue
        
        self.id = "\(title) - \(publishedAt)"
        
        self.setCategory(category)
        self.setSource(source)
    }
    
    func setCategory(_ category: NewsCategory?) {
        self.category = category?.rawValue
    }
    
    func setSource(_ source: NewsSource?) {
        self.source = source?.rawValue
    }
    
    func getCategory() -> NewsCategory? {
        category != nil ? NewsCategory.init(rawValue: category!) : nil
    }
    
    func getSource() -> NewsSource? {
        source != nil ? NewsSource.init(rawValue: source!) : nil
    }
}
