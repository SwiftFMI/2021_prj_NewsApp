//
//  UserInfoManager.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 24.02.22.
//

import Foundation
import RealmSwift

class UserInfoManager {
    static let current = UserInfoManager()
    
    private(set) var userInfo: UserInfoDB?
    
    private init() {
        userInfo = getUserInfo()
    }
    
    func incrementArticlesRead(forCategory category: NewsCategory?) {
        guard
            let realm = try? Realm(),
            let userInfo = userInfo,
            let category = category
        else { return }
        
        realm.safeWrite {
            switch category {
            case .business:
                userInfo.businessArticlesRead += 1
            case .entertainment:
                userInfo.entertainmentArticlesRead += 1
            case .general:
                userInfo.generalArticlesRead += 1
            case .health:
                userInfo.healthArticlesRead += 1
            case .science:
                userInfo.scienceArticlesRead += 1
            case .sports:
                userInfo.sportsArticlesRead += 1
            case .technology:
                userInfo.technologyArticlesRead += 1
            }
        }
    }
    
    /// Returns value in [0;1]. Returns 0 only when a nil category is passed or no user info exits.
    func getRatingForCategory(_ category: NewsCategory?) -> Double {
        guard let category = category, let userInfo = userInfo else {
            return 0
        }
        
        var articlesReadForCategory = 1
        
        switch category {
        case .business:
            articlesReadForCategory = userInfo.businessArticlesRead
        case .entertainment:
            articlesReadForCategory = userInfo.entertainmentArticlesRead
        case .general:
            articlesReadForCategory = userInfo.generalArticlesRead
        case .health:
            articlesReadForCategory = userInfo.healthArticlesRead
        case .science:
            articlesReadForCategory = userInfo.scienceArticlesRead
        case .sports:
            articlesReadForCategory = userInfo.sportsArticlesRead
        case .technology:
            articlesReadForCategory = userInfo.technologyArticlesRead
        }
        
        let alphaValue = 1
        
        return Double(articlesReadForCategory + alphaValue) /
        Double(userInfo.totalArticlesRead + (NewsCategory.allCases.count * alphaValue))
    }
    
    func reloadUserInfo() {
        guard let realm = try? Realm() else { return }
        
        let user = UserInfoDB(id: "1")
        
        realm.safeWrite {
            realm.add(user, update: .modified)
        }
    }
    
    private func getUserInfo() -> UserInfoDB? {
        guard let realm = try? Realm() else { return nil }
        
        return realm.object(ofType: UserInfoDB.self, forPrimaryKey: "1")
    }
}
