//
//  NewsAPIResponse.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 17.02.22.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let articles: [Article]
}
