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
        
        view.backgroundColor = .primaryHighlight
        
        let sideMenuButton = UIButton()
        sideMenuButton.setImage(SystemAssets.listBullet?.withTintColor(UIColor.systemBlue).resizeImage(width: 30), for: .normal)
        sideMenuButton.addTarget(self, action: #selector(showRightSideBar), for: .touchUpInside)
        
        let sideMenuButtonBarButtonItem = UIBarButtonItem(customView: sideMenuButton)
        navigationItem.rightBarButtonItem = sideMenuButtonBarButtonItem
        
        let discoverNewsContentView = UIView()
        discoverNewsContentView.translatesAutoresizingMaskIntoConstraints = false
        
        let newsFeedContentView = UIView()
        newsFeedContentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(discoverNewsContentView)
        view.addSubview(newsFeedContentView)
        
        add(asChildViewController: discoverViewController, contentView: discoverNewsContentView)
        add(asChildViewController: feedViewController, contentView: newsFeedContentView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            discoverNewsContentView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            discoverNewsContentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            discoverNewsContentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            discoverNewsContentView.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -50),
            
            newsFeedContentView.topAnchor.constraint(equalTo: discoverNewsContentView.bottomAnchor),
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
