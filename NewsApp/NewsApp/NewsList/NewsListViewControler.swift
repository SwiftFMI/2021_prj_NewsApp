//
//  NewsListViewControler.swift
//  NewsApp
//
//  Created by Ivaylo Atovski on 19.02.22.
//

import Foundation
import UIKit

class NewsListViewController: UIViewController {
    
    var articles = [ArticleDB]()
    var filtered = [ArticleDB]()
    var category: NewsCategory = NewsCategory.general
    
    private let articleDataSource = NewsArticleDataSource()
    
    var searchBar = UISearchBar()
    var newsTableView = UITableView()
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleDataSource.delegate = self
        articleDataSource.syncArticles(forCountry: .us)
        articleDataSource.loadArticles()
        articles = articleDataSource.getArticles(forCategory: category)?.toArray() ?? []
        
        if articles.isEmpty {
            articles = articleDataSource.articles ?? []
        }
        
        view.backgroundColor = .primaryBackgrond
        
        let sideMenuButton = UIButton()
        sideMenuButton.setImage(SystemAssets.listBullet?.withTintColor(UIColor.systemBlue).resizeImage(width: 30), for: .normal)
        sideMenuButton.addTarget(self, action: #selector(showRightSideBar), for: .touchUpInside)
        
        let sideMenuButtonBarButtonItem = UIBarButtonItem(customView: sideMenuButton)
        navigationItem.rightBarButtonItem = sideMenuButtonBarButtonItem
        
        switch category {
        case NewsCategory.sports:
            navigationItem.title = "Sports"
        case NewsCategory.entertainment:
            navigationItem.title = "Entertainment"
        case NewsCategory.health:
            navigationItem.title = "Health"
        case NewsCategory.business:
            navigationItem.title = "Business"
        case NewsCategory.science:
            navigationItem.title = "Science"
        case NewsCategory.technology:
            navigationItem.title = "Tehnology"
            
        default:
            navigationItem.title = "General"
        }
        
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            searchBar.heightAnchor.constraint(equalToConstant: 30),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.maxY  ?? 0.0) + 10),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
        
        newsTableView.dataSource    = self
        newsTableView.delegate      = self
        newsTableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.identifier)
        
        newsTableView.backgroundColor = .secondaryBackground
        newsTableView.rowHeight = 300
        view.addSubview(newsTableView)
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            newsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            newsTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showRightSideBar() {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.isMenuRevealed ? sideMenuController.hideMenu() : sideMenuController.revealMenu()
    }
}

extension NewsListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filtered.count : articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.identifier,
                                                       for: indexPath) as? NewsListTableViewCell else {
            return UITableViewCell()
        }
        
        if searchActive && filtered.count > indexPath.row {
            cell.setupCell(article: filtered[indexPath.row])
        }else if !searchActive && articles.count > indexPath.row {
            cell.setupCell(article: articles[indexPath.row])
        }
        return cell
    }
}

extension NewsListViewController :UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var articleOpt: ArticleDB? = nil
        
        if searchActive && filtered.count > indexPath.row {
            articleOpt = filtered[indexPath.row]
        } else if !searchActive && articles.count > indexPath.row {
            articleOpt = articles[indexPath.row]
        }
        
        guard let article = articleOpt else { return }
        
        NewsAPISyncer().getImage(forUrl: article.urlToImage, completion: { [weak self] image in
            let newsDetailsViewController = NewsDetailsViewController(withArticle: article, posterImage: image)
            
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(newsDetailsViewController, animated: true)
                tableView.cellForRow(at: indexPath)?.isSelected = false
            }
        })
    }
}

extension NewsListViewController :UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    //func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    //    searchActive = false;
    //}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true;
        filtered = articles.filter({ (article) -> Bool in
            let tmp : NSString = (article.title ?? "")as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if searchText.isEmpty {
            searchActive = false;
        }
        
        self.newsTableView.reloadData()
    }
}

extension NewsListViewController: NewsArticleDataSourceDelegate {
    func newsArticleDataSourceDeletage(willUpdateArticles dataSource: NewsArticleDataSource) {}
    
    func newsArticleDataSourceDelegate(didUpdateArticles dataSource: NewsArticleDataSource) {
        DispatchQueue.main.async { [weak self] in
            self?.newsTableView.reloadData()
        }
    }
}
