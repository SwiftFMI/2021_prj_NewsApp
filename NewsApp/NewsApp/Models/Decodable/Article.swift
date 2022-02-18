//
//  Article.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 17.02.22.
//

import Foundation

struct Article: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}


