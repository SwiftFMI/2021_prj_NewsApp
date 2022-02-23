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
        case .favourites:
            let newsList = NewsListViewController(showOnlyFavourites: true)
            self.pushViewController(newsList, animated: true)
            
        case .logOut:
            AuthState.current.logOut(authControllerPresenter: self)
          
        case SideMenuItemType.science :
            let newsList = NewsListViewController(forCategory: .science)
            self.pushViewController(newsList, animated: true)

        case SideMenuItemType.technology :
            let newsList = NewsListViewController(forCategory: .technology)
            self.pushViewController(newsList, animated: true)
            
        case SideMenuItemType.business :
            let newsList = NewsListViewController(forCategory: .business)
            self.pushViewController(newsList, animated: true)
            
        case SideMenuItemType.health :
            let newsList = NewsListViewController(forCategory: .health)
            self.pushViewController(newsList, animated: true)
            
        case SideMenuItemType.entertainment :
            let newsList = NewsListViewController(forCategory: .entertainment)
            self.pushViewController(newsList, animated: true)
            
        case SideMenuItemType.sports :
            let newsList = NewsListViewController(forCategory: .sports)
            self.pushViewController(newsList, animated: true)
          
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
