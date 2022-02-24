//
//  UserInfoDataSource.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 24.02.22.
//

import Foundation
import RealmSwift

class UserInfoDataSource {
    private(set) var userInfo: UserInfoDB?
    
    init() {
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
