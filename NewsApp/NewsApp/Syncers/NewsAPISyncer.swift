//
//  NewsAPISyncer.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 17.02.22.
//

import Foundation
import Alamofire
import UIKit

fileprivate let baseUrl = "https://newsapi.org/v2/"
fileprivate let topHeadlinesPath = "top-headlines"
fileprivate let everythingPath = "everything"

fileprivate let apiKeys = [
    "41c44882480a4ba78343301163d2c0bd",
    "da12389d61324eaab7565d2144615670",
    "81a97c3ec40040928aadf42a63fa830d",
    "e4bb16fd96074657b022f89caa225e33",
    "9f8e6c14f42241228bc39894bd17e895",
    "aad793f3729f4529a98b566379c6376b",
    "8109c6594e214bc9bdd2f4070aebf969",
    "810ef752800b4b178a604b7780eae69c",
]

class NewsAPISyncer: NSObject {
    
    func getImage(forUrl url: String?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        AF.request(url, method: .get, encoding: URLEncoding.default).response { response in
            guard let data = response.data, response.error == nil else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: data))
        }
    }
    
    /// Atleast one parameter should have a value.
    func getTopHeadlines(forCategory category: NewsCategory? = nil, country: NewsCountry? = .us, query: String? = nil, page: Int = 1, completion: @escaping ([Article]?) -> Void) {
        getTopHeadlines(forCategory: category, source: nil, country: country, query: query, page: page, completion: completion)
    }
    
    func getTopHeadlines(forSource source: NewsSource, query: String? = nil, page: Int = 1, completion: @escaping ([Article]?) -> Void) {
        getTopHeadlines(forCategory: nil, source: source, query: query, page: page, completion: completion)
    }
    
    /// Atleast one parameter should have a value.
    func getAllArticles(forSource source: NewsSource? = nil,
                        query: String? = nil,
                        fromDate: String? = nil,
                        toDate: String? = nil,
                        page: Int = 1,
                        completion: @escaping ([Article]?) -> Void) {
        
        var params: Parameters = [ "apiKey" : apiKeys.randomElement()!, "page" : page ]
        
        if let source = source {
            params["sources"] = source.rawValue
        }
        
        if let query = query {
            params["q"] = query
        }
        
        if let fromDate = fromDate {
            params["from"] = fromDate
        }
        
        if let toDate = toDate {
            params["to"] = toDate
        }
        
        AF.request(baseUrl + everythingPath,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default).response { response in
            
            guard
                let data = response.data,
                let articlesResponse = try? JSONDecoder().decode(NewsAPIResponse.self, from: data)
            else {
                completion(nil)
                return
            }
            
            completion(articlesResponse.articles)
        }
    }
    
    private func getTopHeadlines(forCategory category: NewsCategory? = nil,
                                 source: NewsSource? = nil,
                                 country: NewsCountry? = nil,
                                 query: String? = nil,
                                 page: Int = 1,
                                 completion: @escaping ([Article]?) -> Void) {
        
        var params: Parameters = [ "apiKey" : apiKeys.randomElement()!, "page" : page ]
        
        if let category = category {
            params["category"] = category.rawValue
        }
        
        if let source = source {
            params["sources"] = source.rawValue
        }
        
        if let country = country {
            params["country"] = country.rawValue
        }
        
        if let query = query {
            params["q"] = query
        }
        
        AF.request(baseUrl + topHeadlinesPath,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default).response { response in
            
            guard
                let data = response.data,
                let articlesResponse = try? JSONDecoder().decode(NewsAPIResponse.self, from: data)
            else {
                completion(nil)
                return
            }
            
            completion(articlesResponse.articles)
        }
    }
}
