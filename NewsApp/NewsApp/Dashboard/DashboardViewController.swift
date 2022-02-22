//
//  DashboardViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    private let feedTableView = NewsFeedTableView()
    private let newsSourcesViewController = NewsSourcesViewController()
    
    private let articleDataSource = NewsArticleDataSource()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(syncTable), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        articleDataSource.delegate = self
        articleDataSource.syncArticles(forCountry: .us)
        articleDataSource.loadArticles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackgrond
        
        let sideMenuButton = UIButton()
        sideMenuButton.setImage(SystemAssets.listBullet?.withTintColor(UIColor.systemBlue).resizeImage(width: 30), for: .normal)
        sideMenuButton.addTarget(self, action: #selector(showRightSideBar), for: .touchUpInside)
        
        let sideMenuButtonBarButtonItem = UIBarButtonItem(customView: sideMenuButton)
        navigationItem.rightBarButtonItem = sideMenuButtonBarButtonItem
        navigationItem.title = "Dashboard"

        feedTableView.dataSource = self
        feedTableView.delegate = self
        feedTableView.addSubview(refreshControl)
        
        view.addSubview(feedTableView)
        
        NSLayoutConstraint.activate([
            feedTableView.topAnchor.constraint(equalTo: view.topAnchor),
            feedTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            feedTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    @objc private func syncTable() {
        // TODO: what do we sync and load exactly ?
        articleDataSource.syncArticles(forCountry: .de, completion: { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        })
    }
    
    @objc private func showRightSideBar() {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.isMenuRevealed ? sideMenuController.hideMenu() : sideMenuController.revealMenu()
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleDataSource.articles?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCell.reuseIdentifier, for: indexPath) as? NewsFeedTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(article: articleDataSource.articles?[indexPath.row] ?? nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = articleDataSource.articles?[indexPath.row] else { return }
        
        NewsAPISyncer().getImage(forUrl: article.urlToImage, completion: { [weak self] image in
            let newsDetailsViewController = NewsDetailsViewController(withArticle: article, posterImage: image)
            
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(newsDetailsViewController, animated: true)
                tableView.cellForRow(at: indexPath)?.isSelected = false
            }
        })
        
    }
}

extension DashboardViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView = UIView()
        
        add(asChildViewController: newsSourcesViewController, contentView: contentView)
        
        return contentView
    }
}

extension DashboardViewController: NewsArticleDataSourceDelegate {
    func newsArticleDataSourceDeletage(willUpdateArticles dataSource: NewsArticleDataSource) {}
    
    func newsArticleDataSourceDelegate(didUpdateArticles dataSource: NewsArticleDataSource) {
        DispatchQueue.main.async { [weak self] in
            self?.feedTableView.reloadData()
        }
    }
}

