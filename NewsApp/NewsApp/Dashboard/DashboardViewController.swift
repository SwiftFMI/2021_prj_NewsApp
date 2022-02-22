//
//  DashboardViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    let discoverViewController = DiscoverNewsViewController()
    let feedViewController = NewsFeedViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackgrond
        
        let sideMenuButton = UIButton()
        sideMenuButton.setImage(SystemAssets.listBullet?.withTintColor(UIColor.systemBlue).resizeImage(width: 30), for: .normal)
        sideMenuButton.addTarget(self, action: #selector(showRightSideBar), for: .touchUpInside)
        
        let sideMenuButtonBarButtonItem = UIBarButtonItem(customView: sideMenuButton)
        navigationItem.rightBarButtonItem = sideMenuButtonBarButtonItem
        
        let newsFeedContentView = UIView()
        newsFeedContentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(newsFeedContentView)
        
        add(asChildViewController: feedViewController, contentView: newsFeedContentView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            newsFeedContentView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            newsFeedContentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            newsFeedContentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            newsFeedContentView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    @objc private func showRightSideBar() {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.isMenuRevealed ? sideMenuController.hideMenu() : sideMenuController.revealMenu()
    }
}
