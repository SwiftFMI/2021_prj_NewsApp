//
//  DashboardViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    
    private let articleDataSource = NewsArticleDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackgrond
        
        let sideMenuButton = UIButton()
        sideMenuButton.setImage(SystemAssets.listBullet?.withTintColor(UIColor.systemBlue).resizeImage(width: 30), for: .normal)
        sideMenuButton.addTarget(self, action: #selector(showRightSideBar), for: .touchUpInside)
        
        let sideMenuButtonBarButtonItem = UIBarButtonItem(customView: sideMenuButton)
        navigationItem.rightBarButtonItem = sideMenuButtonBarButtonItem
        
        articleDataSource.delegate = self
        articleDataSource.loadArticles()
        articleDataSource.syncArticles(forCountry: .bg)
        
        let discoverTitle = UILabel()
        discoverTitle.text = "Discover"
        view.addSubview(discoverTitle)
        
        let discoverNewsCard = DiscoverNewsCard()
        discoverNewsCard.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2 - 50)
        self.addChild(discoverNewsCard)
        self.view.addSubview(discoverNewsCard.view)
        
        let newsCard = NewsCard()
        newsCard.view.frame = CGRect(x: 0, y: 370, width: self.view.frame.width, height: self.view.frame.height/2)
        self.addChild(newsCard)
        self.view.addSubview(newsCard.view)
        
        NSLayoutConstraint.activate([
            discoverTitle.topAnchor.constraint(equalTo: view.topAnchor),
            discoverTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            discoverTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            discoverNewsCard.view.topAnchor.constraint(equalTo: view.bottomAnchor),
            newsCard.view.topAnchor.constraint(equalTo: discoverNewsCard.view.bottomAnchor),
            newsCard.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func showRightSideBar() {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.isMenuRevealed ? sideMenuController.hideMenu() : sideMenuController.revealMenu()
    }
}

extension DashboardViewController: NewsArticleDataSourceDelegate {
    func newsArticleDataSourceDeletage(willUpdateArticles dataSource: NewsArticleDataSource) {
        NSLog("willUpdate")
    }
    
    func newsArticleDataSourceDelegate(didUpdateArticles dataSource: NewsArticleDataSource) {
       // NSLog("\(articleDataSource.articles)")
    }
}
