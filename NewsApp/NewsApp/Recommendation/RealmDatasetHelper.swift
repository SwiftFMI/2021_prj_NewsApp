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
        var csvString = "Article ID,Category,Recommendation Value\r\n"
        
        categorizedArticles?.forEach { article in
            csvString = csvString.appending("\(article.id?.withQuotationMarksRaw() ?? ""),\( article.getCategory()?.rawValue ?? ""),\(article.recommendationValue)\r\n")
        }
        let fileManager = FileManager.default
        
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("NewsAppRecommendationModel.csv")
            
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("error creating file")
        }

// Just an example on how to parse it back to an array of arrays of strings
//        var data = ""
//
//        do {
//            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let fileURL = path.appendingPathComponent("NewsAppRecommendationModel.csv")
//
//            data = try String(contentsOf: fileURL)
//
//            var stringFromCsv = parseCsv(data)
//            stringFromCsv.removeFirst()
//
//            NSLog("\(stringFromCsv)")
//        } catch {
//            print(error)
//            return
//        }
    }
    
    func parseCsv(_ data: String) -> [[String]] {
        // data: String = contents of a CSV file.
        // Returns: [[String]] = two-dimension array [rows][columns].
        // Data minimum two characters or fail.
        if data.count < 2 {
            return []
        }
        var a: [String] = [] // Array of columns.
        var index: String.Index = data.startIndex
        let maxIndex: String.Index = data.index(before: data.endIndex)
        var q: Bool = false // "Are we in quotes?"
        var result: [[String]] = []
        var v: String = "" // Column value.
        
        while index < data.endIndex {
            if q { // In quotes.
                if (data[index] == "\"") {
                    // Found quote; look ahead for another.
                    if index < maxIndex && data[data.index(after: index)] == "\"" {
                        // Found another quote means escaped.
                        // Increment and add to column value.
                        data.formIndex(after: &index)
                        v += String(data[index])
                    } else {
                        // Next character not a quote; last quote not escaped.
                        q = !q // Toggle "Are we in quotes?"
                    }
                } else {
                    // Add character to column value.
                    v += String(data[index])
                }
            } else { // Not in quotes.
                if data[index] == "\"" {
                    // Found quote.
                    q = !q // Toggle "Are we in quotes?"
                } else if data[index] == "\r" || data[index] == "\r\n" {
                    // Reached end of line.
                    // Column and row complete.
                    a.append(v)
                    v = ""
                    result.append(a)
                    a = []
                } else if data[index] == "," {
                    // Found comma; column complete.
                    a.append(v)
                    v = ""
                } else {
                    // Add character to column value.
                    v += String(data[index])
                }
            }
            if index == maxIndex {
                // Reached end of data; flush.
                if v.count > 0 || data[data.index(before: index)] == "," {
                    a.append(v)
                }
                if a.count > 0 {
                    result.append(a)
                }
                break
            }
            data.formIndex(after: &index) // Increment.
        }
        
        return result
    }
}
