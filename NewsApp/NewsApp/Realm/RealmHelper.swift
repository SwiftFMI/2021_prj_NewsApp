//
//  RealmHelper.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 18.02.22.
//

import Foundation
import RealmSwift
import UIKit

class RealmHelper {
    
    static func observeRealmTableResults<T>(tableView: UITableView,
                                            results: Results<T>,
                                            otherActions: @escaping () -> Void = {}) -> NotificationToken {
        return observeRealmTableResults(tableView: tableView,
                                        results: results,
                                        otherActions: {_,_,_,_ in otherActions()})
    }
    
    static func observeRealmTableResults<T>(tableView: UITableView,
                                            results: Results<T>,
                                            otherActions: @escaping ( Bool, Bool, Bool, Bool) -> Void) -> NotificationToken {
        return results.observe { (changes: RealmCollectionChange) in
            var initial = false
            var deleted = false
            var inserted = false
            var modified = false
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                initial = true
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                deleted = deletions.count > 0
                inserted = insertions.count > 0
                modified = modifications.count > 0

                if deletions.isEmpty && insertions.isEmpty {
                    UIView.performWithoutAnimation {
                        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                with: .none)
                    }
                } else {
                    // Always apply updates in the following order: deletions, insertions, then modifications.
                    // Handling insertions before deletions may result in unexpected behavior.
                    tableView.performBatchUpdates({
                        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    }, completion: nil)
                }
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }

            otherActions(initial, deleted, inserted, modified)
        }
    }

    static func observeRealmCollectionResults<T>(collectionView: UICollectionView,
                                                 results: Results<T>,
                                                 otherActions: @escaping () -> Void = {}) -> NotificationToken {
        return results.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, apply them to the UICollectionView
                // Always apply updates in the following order: deletions, insertions, then modifications.
                // Handling insertions before deletions may result in unexpected behavior.
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: deletions.map({ IndexPath(item: $0, section: 0) }))
                    collectionView.insertItems(at: insertions.map({ IndexPath(item: $0, section: 0) }))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(item: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }

            otherActions()
        }
    }
    
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
