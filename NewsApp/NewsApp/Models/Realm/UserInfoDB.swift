//
//  UserInfoDB.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 24.02.22.
//

import Foundation
import RealmSwift

class UserInfoDB: Object {
    @objc dynamic var id: String?
    
    @objc dynamic var businessArticlesRead: Int = 1
    @objc dynamic var entertainmentArticlesRead: Int = 1
    @objc dynamic var generalArticlesRead: Int = 1
    @objc dynamic var healthArticlesRead: Int = 1
    @objc dynamic var scienceArticlesRead: Int = 1
    @objc dynamic var sportsArticlesRead: Int = 1
    @objc dynamic var technologyArticlesRead: Int = 1
    
    var totalArticlesRead: Int {
        businessArticlesRead + entertainmentArticlesRead + generalArticlesRead + healthArticlesRead + scienceArticlesRead + sportsArticlesRead + technologyArticlesRead
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String? = "1", businessArticlesRead: Int = 0, entertainmentArticlesRead: Int = 0, generalArticlesRead: Int = 0, healthArticlesRead: Int = 0, scienceArticlesRead: Int = 0, sportsArticlesRead: Int = 0, technologyArticlesRead: Int = 0) {
        self.init()
        self.id = id
        self.businessArticlesRead = businessArticlesRead
        self.entertainmentArticlesRead = entertainmentArticlesRead
        self.generalArticlesRead = generalArticlesRead
        self.healthArticlesRead = healthArticlesRead
        self.scienceArticlesRead = scienceArticlesRead
        self.sportsArticlesRead = sportsArticlesRead
        self.technologyArticlesRead = technologyArticlesRead
    }
}
