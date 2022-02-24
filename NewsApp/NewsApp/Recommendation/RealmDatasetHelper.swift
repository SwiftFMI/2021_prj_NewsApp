//
//  RealmDatasetHelper.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 24.02.22.
//

import Foundation
import RealmSwift

class RealmDatasetHelper {
    private(set) var categorizedArticles: Results<ArticleDB>?
    private var notificationToken: NotificationToken?
    
    init() {
        loadCategorizedArticles()
    }
    
    deinit {
        notificationToken = nil
    }
    
    func loadCategorizedArticles() {
        notificationToken = nil
        
        categorizedArticles = getCategorizedArticles()
        
        updateCsvFile()
        
        if let categorizedArticles = categorizedArticles {
            notificationToken = RealmHelper.observeResults(categorizedArticles, actions: { [weak self] changes in
                if let self = self {
                    self.categorizedArticles = categorizedArticles
                    self.updateCsvFile()
                }
            })
        }
    }
    
    func getCategorizedArticles(sortOptions: [RealmSwift.SortDescriptor]? = nil) -> Results<ArticleDB>? {
        guard let realm = try? Realm() else {
            return nil
        }
        
        let sort = sortOptions ?? [SortDescriptor(keyPath: "recommendationValue", ascending: false)]
        
        return realm.objects(ArticleDB.self).filter(NSPredicate(format: "category != nil")).sorted(by: sort)
    }
    
    func updateCsvFile() {
        // not sure how to just update changes from realm to csv using `changes`, so just creating a new csv on realm update
        var csvString = "\("Article ID"),\("Category"),\("Recommendation Value")\n\n"
        
        categorizedArticles?.forEach { article in
            csvString = csvString.appending("\(String(describing: article.id)) ,\(String(describing: article.getCategory()?.rawValue)), \(String(describing: article.recommendationValue))\n")
        }
        
        let fileManager = FileManager.default
        
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("NewsAppRecommendationModel.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("error creating file")
        }
    }
}
