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
        articleDataSource.syncArticles(forCountry: .us)
        
        let article = articleDataSource.articles?.randomElement()
        NewsAPISyncer().getImage(forUrl: article?.urlToImage, completion: { [weak self] posterImage in
            let ndvc = NewsDetailsViewController(withArticle: article, posterImage: posterImage)
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(ndvc, animated: true)
            }
        })

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
        NSLog("didUpdate")
    }
}
