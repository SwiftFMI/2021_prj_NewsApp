//
//  NewsListViewControler.swift
//  NewsApp
//
//  Created by Ivaylo Atovski on 19.02.22.
//

import Foundation
import UIKit

class NewsListViewController: UIViewController {
    private var articleDataSource: NewsArticleDataSource?
    private var filtered = [ArticleDB]()
    
    private var model = NewsRecommender2()
    private var recommendedNews: [String] = []
    
    private var searchBar = UISearchBar()
    private var newsTableView = UITableView()
    private var searchActive: Bool = false
    private var navigationItemTitle: String?
    
    // super cheezy shit going on around this
    private var syncArticles: (() -> Void?)?
    
    init(forCategory category: NewsCategory) {
        super.init(nibName: nil, bundle: nil)
        
        articleDataSource = NewsArticleDataSource(withArticleCategory: category, withNewsArticleDataSourceDelegate: self, loadOnInit: true)
        
        syncArticles = { [weak self] in self?.articleDataSource?.syncArticles(forCategory: category) }
        
        navigationItemTitle = category.rawValue.capitalizeFirst()
    }
    
    init(forSource sourceDisplay: NewsSourceDisplay) {
        super.init(nibName: nil, bundle: nil)
        
        articleDataSource = NewsArticleDataSource(withArticleSource: sourceDisplay.source, withNewsArticleDataSourceDelegate: self, loadOnInit: true)
        
        syncArticles = { [weak self] in self?.articleDataSource?.syncArticles(fromSource: sourceDisplay.source) }
        
        navigationItemTitle = sourceDisplay.displayName
    }
    
    init(showOnlyFavourites onlyFavourites: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        articleDataSource = NewsArticleDataSource(withNewsArticleDataSourceDelegate: self, loadOnInit: false)
        articleDataSource?.loadFavouriteArticles()
        
        navigationItemTitle = "Favourites"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        articleDataSource = NewsArticleDataSource(withNewsArticleDataSourceDelegate: self, loadOnInit: false)
        
        navigationItemTitle = "Recommended"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncArticles?()
        
        view.backgroundColor = .primaryBackgrond
        
        let sideMenuButton = UIButton()
        sideMenuButton.setImage(SystemAssets.listBullet?.withTintColor(UIColor.systemBlue).resizeImage(width: 30), for: .normal)
        sideMenuButton.addTarget(self, action: #selector(showRightSideBar), for: .touchUpInside)
        
        let sideMenuButtonBarButtonItem = UIBarButtonItem(customView: sideMenuButton)
        navigationItem.rightBarButtonItem = sideMenuButtonBarButtonItem
        
        navigationItem.title = navigationItemTitle
        
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
        newsTableView.showsVerticalScrollIndicator = false
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
        
        newsTableView.reloadData()
        
        
        let rec = RealmDatasetHelper()
    }
    
    @objc private func showRightSideBar() {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.isMenuRevealed ? sideMenuController.hideMenu() : sideMenuController.revealMenu()
    }
    
    private func setRecommendations(forArticle article: ArticleDB) {
        guard let articleId = article.id else { return }
        
        let user = [articleId : article.recommendationValue]
        
        // Creating an canstant of type CocktailModel1Input, that the model needs to make the recommendations
        let input = NewsRecommender2Input(items: user, k: 10)
        
        // Safely unwraping the prdiction that the model returns, because its optional and we need to assign it to a constant, that wll hold the results
        guard let unwrappedResults = try? model.prediction(input: input) else {
            fatalError("Could not get results back!")
        }
        
        // This constant will hold the .recommendations from the returned resuls from the model. They are in order from most relevant to least relevant
        let results = unwrappedResults.scores
        
        articleDataSource?.loadAllArticles(forIds: Array(results.keys))
        
        for (articleId, _) in results {
            recommendedNews.append(articleId)
            print("BACA", articleId)
        }
    }
}

extension NewsListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filtered.count : (articleDataSource?.articles?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.identifier,
                                                       for: indexPath) as? NewsListTableViewCell else {
            return UITableViewCell()
        }
        
        if searchActive && filtered.count > indexPath.row {
            cell.setupCell(article: filtered[indexPath.row])
        } else if !searchActive && (articleDataSource?.articles?.count ?? 0) > indexPath.row {
            cell.setupCell(article: articleDataSource?.articles?[indexPath.row])
        }
        
        return cell
    }
}

extension NewsListViewController :UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var articleOpt: ArticleDB? = nil
        
        if searchActive && filtered.count > indexPath.row {
            articleOpt = filtered[indexPath.row]
        } else if !searchActive && (articleDataSource?.articles?.count ?? 0) > indexPath.row {
            articleOpt = articleDataSource?.articles?[indexPath.row]
        }
        
        guard let article = articleOpt else { return }
        
        NewsAPISyncer().getImage(forUrl: article.urlToImage, completion: { [weak self] image in
            let newsDetailsViewController = NewsDetailsViewController(withArticle: article, posterImage: image)
            
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(newsDetailsViewController, animated: true)
                tableView.cellForRow(at: indexPath)?.isSelected = false
            }
        })
        
        setRecommendations(forArticle: article)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 5 {
            syncArticles?()
        }
    }
}

extension NewsListViewController :UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true;
        filtered = articleDataSource?.articles?.filter({ (article) -> Bool in
            let tmp : NSString = (article.title ?? "")as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        }) ?? []
        
        if searchText.isEmpty {
            searchActive = false;
        }
        
        self.newsTableView.reloadData()
        if self.newsTableView.numberOfRows(inSection: 0) > 0{
            let topRow = IndexPath(row: 0, section: 0)
            self.newsTableView.scrollToRow(at: topRow, at: .top, animated: true)
        }
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
