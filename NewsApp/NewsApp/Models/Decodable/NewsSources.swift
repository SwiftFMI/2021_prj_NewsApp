//
//  NewsSources.swift
//  NewsApp
//
//  Created by ZehraIliyaz  on 18.02.22.
//

import Foundation

struct NewsSourceDisplay {
    let source: NewsSource
    let displayName: String
}

struct RecommendedNewsSources {
    let sources = [
        NewsSourceDisplay(source: .Bloomberg, displayName: "Bloomberg"),
        NewsSourceDisplay(source: .DailyMail, displayName: "Daily Mail"),
        NewsSourceDisplay(source: .FoxSports, displayName: "Fox Sports"),
        NewsSourceDisplay(source: .Google, displayName: "Google News"),
        NewsSourceDisplay(source: .TheGuardianUK, displayName: "The Guardian UK"),
        NewsSourceDisplay(source: .Metro, displayName: "Metro"),
        NewsSourceDisplay(source: .NatGeo, displayName: "National Geographics"),
        NewsSourceDisplay(source: .Reddit, displayName: "Reddit"),
        NewsSourceDisplay(source: .TheEconomist, displayName: "The Economist"),
        NewsSourceDisplay(source: .BBC, displayName: "BBC News"),
        NewsSourceDisplay(source: .AustralianBroadcastCorporation, displayName: "ABC News"),
        NewsSourceDisplay(source: .TechCrunch, displayName: "Tech Crunch"),
    ]
}
