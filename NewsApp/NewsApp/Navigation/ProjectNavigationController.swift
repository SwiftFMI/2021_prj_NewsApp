//
//  ProjectNavigationController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

class ProjectNavigationController: UINavigationController {
    private var currentActiveSection: SideMenuItemType = .dashboard
}

extension ProjectNavigationController: SideMenuViewControllerDelegate {
    func menuViewController(_ controller: SideMenuViewController, didChangeMenuItem item: SideMenuItemType) {
        currentActiveSection = item
        
        switch currentActiveSection {
            //TODO: add cases for navigation items tap
        default:
            break
        }
    }
    
    func performClose(_ controller: SideMenuViewController) {
        sideMenuController?.hideMenu()
    }
    
    func menuViewControllerCurrentActiveItem(_ controller: SideMenuViewController) -> SideMenuItemType {
        return currentActiveSection
    }
}
