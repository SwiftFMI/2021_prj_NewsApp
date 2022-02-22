//
//  NewsFeedViewController.swift
//  NewsApp
//
//  Created by ZehraIliyaz  on 19.02.22.
//

import Foundation
import UIKit

class NewsFeedViewController: UIViewController {
    private let articleDataSource = NewsArticleDataSource()
    private let feedTableView = NewsFeedTableView()
    
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

        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        view.addSubview(feedTableView)
        
        NSLayoutConstraint.activate([
            feedTableView.topAnchor.constraint(equalTo: view.topAnchor),
            feedTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            feedTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

extension NewsFeedViewController: UITableViewDataSource {
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

extension NewsFeedViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        
        add(asChildViewController: DiscoverNewsViewController(), contentView: containerView)
        
        return containerView
    }
}

extension NewsFeedViewController: NewsArticleDataSourceDelegate {
    func newsArticleDataSourceDeletage(willUpdateArticles dataSource: NewsArticleDataSource) {}
    
    func newsArticleDataSourceDelegate(didUpdateArticles dataSource: NewsArticleDataSource) {
        DispatchQueue.main.async { [weak self] in
            self?.feedTableView.reloadData()
        }
    }
}
