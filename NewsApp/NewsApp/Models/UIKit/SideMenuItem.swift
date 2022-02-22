//
//  SideMenuItem.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

enum SideMenuItemType {
    case dashboard, favourites, recommended, science, technology, business, health, entertainment, sports
}

struct SideMenuItem {
    let image: UIImage?
    let tintColor: UIColor
    let title: String
    let type: SideMenuItemType
}

struct MenuItems {
    let mainItems = [
        SideMenuItem(image: SystemAssets.listDashHeaderRectangle, tintColor: .primaryStaticText, title: "Dashboard", type: .dashboard),
        SideMenuItem(image: SystemAssets.heartFill, tintColor: .primaryStaticText, title: "Favourites", type: .favourites),
        SideMenuItem(image: SystemAssets.presonFillViewfinder, tintColor: .primaryStaticText, title: "Recommended", type: .recommended),
    ]
    
    let categories = [
        SideMenuItem(image: SystemAssets.testtube2, tintColor: .primaryStaticText, title: "Science", type: .science),
        SideMenuItem(image: SystemAssets.externalDrive, tintColor: .primaryStaticText, title: "Technology", type: .technology),
        SideMenuItem(image: SystemAssets.dollarSignFill, tintColor: .primaryStaticText, title: "Business", type: .business),
        SideMenuItem(image: SystemAssets.leafCircleFill, tintColor: .primaryStaticText, title: "Health", type: .health),
        SideMenuItem(image: SystemAssets.tvInsetFilled, tintColor: .primaryStaticText, title: "Entertainment", type: .entertainment),
        SideMenuItem(image: SystemAssets.sportscourt, tintColor: .primaryStaticText, title: "Sports", type: .sports)
    ]
    
    func getIndex(type: SideMenuItemType) -> (section: Int, row: Int) {
        switch type {
        case .dashboard:
            return (0, 0)
        case .favourites:
            return (0, 1)
        case .recommended:
            return (0, 2)
        case .business:
            return (1, 0)
        case .science:
            return (1, 1)
        case .technology:
            return (1, 2)
        case .health:
            return (1, 3)
        case .entertainment:
            return (1, 4)
        case .sports:
            return (1, 5)
        }
        
    }
}
