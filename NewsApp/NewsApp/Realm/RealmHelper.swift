//
//  RealmHelper.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 18.02.22.
//

import Foundation
import RealmSwift

class RealmHelper {
    static func observeResults<T>(_ results: Results<T>, actions: @escaping (_ changes: RealmCollectionChange<Results<T>>) -> Void) -> NotificationToken {
        results.observe(actions)
    }
    
    static func nuke() {
        guard let realm = try? Realm() else {
            return
        }
        
        realm.safeWrite {
            realm.deleteAll()
        }
    }
}
