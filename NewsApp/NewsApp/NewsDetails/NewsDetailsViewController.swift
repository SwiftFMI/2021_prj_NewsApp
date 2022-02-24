//
//  NewsDetailsViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 20.02.22.
//

import Foundation
import UIKit
import RealmSwift

class NewsDetailsViewController: UIViewController {
    private let article: ArticleDB?
    
    private let scrollView = UIScrollView()
    private let detailsView: NewsDetailsView
    
    init(withArticle article: ArticleDB?, posterImage: UIImage?) {
        self.article = article
        
        detailsView = NewsDetailsView(isArticleFavourite: article?.favourite)
        
        super.init(nibName: nil, bundle: nil)
        
        detailsView.setArticle(article, withPosterImage: posterImage)
        detailsView.interactionDelegate = self
        
        UserInfoManager.current.incrementArticlesRead(forCategory: article?.getCategory())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = article?.getSource()?.rawValue
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .primaryBackgrond
        scrollView.isScrollEnabled = true
        scrollView.addSubview(detailsView)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            detailsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        guard article != nil else {
            presentArticleNotFoundAlert()
            return
        }
        
        view.setNeedsLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: detailsView.frame.width, height: detailsView.frame.width)
    }
    
    private func presentArticleNotFoundAlert() {
        let alert = UIAlertController(title: "Article not found!", message: "The requested article cannot be found.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) -> Void in
            self?.navigationController?.popViewController(animated: true)
        })
       
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension NewsDetailsViewController: NewsDetailsViewDelegate {
    func newsDetailsViewDelegate(didTapOpenFullButton newsDetailsView: NewsDetailsView) {
        if let articleUrl = article?.url, let url = URL(string: articleUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    func newsDetailsViewDelegate(didTapSaveButton newsDetailsView: NewsDetailsView) {
        guard let realm = try? Realm(),
              let article = article
        else { return }

        newsDetailsView.toggleFavouriteButtonStyle()
        
        realm.safeWrite {
            article.favourite.toggle()
            realm.add(article, update: .modified)
            // Shite, should not need to add the object after modification, but it is how it is
        }
    }
}
