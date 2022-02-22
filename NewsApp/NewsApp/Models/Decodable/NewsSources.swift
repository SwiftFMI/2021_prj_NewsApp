//
//  NewsSources.swift
//  NewsApp
//
//  Created by ZehraIliyaz  on 18.02.22.
//

import Foundation

struct Source: Decodable {
    var image: String
    var name: String
}

struct NewsSourceDescriptor {
    
   static func parseFromJson() -> [Source] {
        let JSON = """
        [
          {
            "image": "bloomberg.png",
            "name": "Bloomberg"
          },
          {
            "image": "daily-mail.png",
            "name": "Daily Mail"
          },
          {
            "image": "fox-sports.png",
            "name": "Fox Sports"
          },
          {
            "image": "google-news.jpeg",
            "name": "Google News"
          },
          {
            "image": "the-guardian.png",
            "name": "The Guardian"
          },
          {
            "image": "metro.jpeg",
            "name": "Metro"
          },
          {
            "image": "national-geographic.jpeg",
            "name": "NatGeo"
          },
          {
            "image": "reddit.jpeg",
            "name": "Reddit"
          },
          {
            "image": "the-economist.png",
            "name": "The Economist"
          },
          {
            "image": "bbc-news.png",
            "name": "BBC News"
          },
          {
            "image": "abc-news.png",
            "name": "ABC News"
          },
          {
            "image": "tech-crunch.jpg",
            "name": "Tech Crunch"
          }
        ]

        """
        
        let jsonData = JSON.data(using: .utf8)!
        let sources: [Source] = try! JSONDecoder().decode([Source].self, from: jsonData)
        return sources
    }
}
