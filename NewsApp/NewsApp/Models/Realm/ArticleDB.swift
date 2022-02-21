//
//  ArticleDB.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 17.02.22.
//

import Foundation
import RealmSwift

struct iPad: Hashable {
    var serialNumber: String
    var capacity: Int
}

class ArticleDB: Object {
    @objc dynamic var id: String?
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var articleDescription: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: String?
    @objc dynamic var content: String?
    
    @objc dynamic var category: String?
    @objc dynamic var source: String?
    @objc dynamic var favourite: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(author: String? = nil, title: String? = nil, articleDescription: String? = nil, url: String? = nil, urlToImage: String? = nil, publishedAt: String? = nil, content: String? = nil, category: NewsCategory? = nil) {
        self.init()
        
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.category = category?.rawValue
        
        var hasher = Hasher()
        hasher.combine(title)
        hasher.combine(publishedAt)
        
        self.id = hasher.finalize().description
    }
    
    func setCategory(fromEnum category: NewsCategory) {
        self.category = category.rawValue
    }
    
    func getCategoryEnum() -> NewsCategory? {
        category != nil ? NewsCategory.init(rawValue: category!) : nil
    }
}
