//
//  DashboardViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryHighlight
        
        let sideMenuButton = UIButton()
        sideMenuButton.setImage(SystemAssets.listBullet?.withTintColor(UIColor.systemBlue).resizeImage(width: 30), for: .normal)
        sideMenuButton.addTarget(self, action: #selector(showRightSideBar), for: .touchUpInside)
        
        let sideMenuButtonBarButtonItem = UIBarButtonItem(customView: sideMenuButton)
        navigationItem.rightBarButtonItem = sideMenuButtonBarButtonItem
        
        //TODO: Use constraints instead of frames
        let discoverNewsCard = DiscoverNewsCard()
       //discoverNewsCard.view.translatesAutoresizingMaskIntoConstraints = false
       discoverNewsCard.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2 - 50)
        self.addChild(discoverNewsCard)
        self.view.addSubview(discoverNewsCard.view)
        
        //TODO: Use constraints instead of frames
        let newsCard = NewsCard()
        //newsCard.view.translatesAutoresizingMaskIntoConstraints = false
        newsCard.view.frame = CGRect(x: 0, y: 370, width: self.view.frame.width, height: self.view.frame.height/2)
        self.addChild(newsCard)
        self.view.addSubview(newsCard.view)
        
        NSLayoutConstraint.activate([
         //   discoverNewsCard.view.topAnchor.constraint(equalTo: view.topAnchor),
            newsCard.view.topAnchor.constraint(equalTo: discoverNewsCard.view.bottomAnchor),
            newsCard.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func showRightSideBar() {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.isMenuRevealed ? sideMenuController.hideMenu() : sideMenuController.revealMenu()
    }
}
