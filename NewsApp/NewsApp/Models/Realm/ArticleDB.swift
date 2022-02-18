//
//  ArticleDB.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 17.02.22.
//

import Foundation
import RealmSwift

class ArticleDB: Object {
    @objc dynamic var id: String = ""
//    @objc dynamic var username: String = ""
//    @objc dynamic var publicKey: String = ""
//    @objc dynamic var privateKey: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
}
