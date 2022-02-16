//
//  SideMenuItem.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

enum SideMenuItemType {
    case dashboard, favourites, recommended, politics, technology, business, health
}

struct SideMenuItem {
    let image: UIImage?
    let tintColor: UIColor
    let title: String
    let type: SideMenuItemType
}

struct MenuItems {
    let mainItems = [
        // TODO: change image assets
        SideMenuItem(image: SystemAssets.personCropCircle, tintColor: .systemBlue, title: "Dashboard", type: .dashboard),
        SideMenuItem(image: SystemAssets.gearCircle, tintColor: .systemBlue, title: "Favourites", type: .favourites),
        SideMenuItem(image: SystemAssets.arrowShapeUpRightCircle, tintColor: .systemBlue, title: "Recommended", type: .recommended),
    ]
    
    let categories = [
        // TODO: change image assets
        SideMenuItem(image: SystemAssets.xmarkCircle, tintColor: .systemRed, title: "Politics", type: .politics),
        SideMenuItem(image: SystemAssets.key, tintColor: .systemGreen, title: "Technology", type: .technology),
        SideMenuItem(image: SystemAssets.key, tintColor: .systemGreen, title: "Business", type: .business),
        SideMenuItem(image: SystemAssets.key, tintColor: .systemGreen, title: "Health", type: .health),
    ]
    
    func getIndex(type: SideMenuItemType) -> (section: Int, row: Int) {
        switch type {
        case .dashboard:
            return (0, 0)
        case .favourites:
            return (0, 1)
        case .recommended:
            return (0, 2)
        case .politics:
            return (1, 0)
        case .technology:
            return (1, 1)
        case .business:
            return (1, 2)
        case .health:
            return (1, 3)
        }
        
    }
}
