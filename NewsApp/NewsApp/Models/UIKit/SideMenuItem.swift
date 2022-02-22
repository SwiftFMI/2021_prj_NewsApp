//
//  SideMenuItem.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

enum SideMenuItemType {
    case dashboard, favourites, recommended, politics, technology, business, health, entertainment, logOut
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
        SideMenuItem(image: SystemAssets.arrowUTurnLeft, tintColor: .primaryStaticText, title: "Log Out", type: .logOut)
    ]
    
    let categories = [
        SideMenuItem(image: SystemAssets.personTwoCircle, tintColor: .primaryStaticText, title: "Politics", type: .politics),
        SideMenuItem(image: SystemAssets.externalDrive, tintColor: .primaryStaticText, title: "Technology", type: .technology),
        SideMenuItem(image: SystemAssets.dollarSignFill, tintColor: .primaryStaticText, title: "Business", type: .business),
        SideMenuItem(image: SystemAssets.leafCircleFill, tintColor: .primaryStaticText, title: "Health", type: .health),
        SideMenuItem(image: SystemAssets.tvInsetFilled, tintColor: .primaryStaticText, title: "Entertainment", type: .entertainment)
    ]
    
    func getIndex(type: SideMenuItemType) -> (section: Int, row: Int) {
        switch type {
        case .dashboard:
            return (0, 0)
        case .favourites:
            return (0, 1)
        case .recommended:
            return (0, 2)
        case .logOut:
            return (0, 3)
        case .politics:
            return (1, 0)
        case .technology:
            return (1, 1)
        case .business:
            return (1, 2)
        case .health:
            return (1, 3)
        case .entertainment:
            return (1, 4)
        }
        
    }
}
