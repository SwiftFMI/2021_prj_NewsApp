//
//  NewsCard.swift
//  NewsApp
//
//  Created by ZehraIliyaz  on 19.02.22.
//

import Foundation
import UIKit

class NewsCard: UIViewController {

    private let articleDataSource = NewsArticleTableViewDataSource()
    
    var tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articleDataSource.loadArticles()
        articleDataSource.syncArticles(forCountry: .bg)
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .primaryBackgrond
        
        tableView.delegate = self
        tableView.dataSource = self
        articleDataSource.tableView = tableView
        tableView.register(NewsCardCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

extension NewsCard: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleDataSource.articles?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsCardCell else {
            return UITableViewCell()
        }
        cell.setupCell(article: articleDataSource.articles?[indexPath.row] ?? nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Present NewsDetailsView
    }
}

extension NewsCard: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return articleDataSource.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        
        let headerTitle = UILabel()
        headerTitle.text = "Top Headlines"
        headerTitle.textColor = .primaryHighlight
        headerTitle.font = UIFont.newsAppFont(ofSize: 25, weight: .bold)
        headerTitle.textAlignment = .center
        headerTitle.backgroundColor = .primaryBackgrond
        
        containerView.addSubview(headerTitle)
        return headerTitle
    }
}

//MARK: UITableViewCell
class NewsCardCell: UITableViewCell {
    
    var rightImage = UIImageView()
    var title = UILabel()
    var context = UILabel()
    var date = UILabel()
    var category = UILabel()
    var separator = UIView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        backgroundColor = .white

        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .primaryStaticText
        title.font = UIFont.newsAppFont(ofSize: 17, weight: .bold)
        
        rightImage.contentMode = .scaleAspectFill
        rightImage.clipsToBounds = true
        rightImage.layer.cornerRadius = 10
        
        rightImage.translatesAutoresizingMaskIntoConstraints = false
        context.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        category.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        
        contentView.addSubview(title)
        contentView.addSubview(rightImage)
        contentView.addSubview(context)
        contentView.addSubview(date)
        contentView.addSubview(category)
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            rightImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rightImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            rightImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rightImage.widthAnchor.constraint(equalToConstant: 120),
            rightImage.heightAnchor.constraint(equalToConstant: 130),

            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: rightImage.trailingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            context.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            context.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            context.leadingAnchor.constraint(equalTo: rightImage.trailingAnchor, constant: 5),
            
            date.topAnchor.constraint(equalTo: context.bottomAnchor, constant: 10),
            date.leadingAnchor.constraint(equalTo: rightImage.trailingAnchor, constant: 5),
            
            separator.heightAnchor.constraint(equalToConstant: 15),
            separator.widthAnchor.constraint(equalToConstant: 2),
            separator.leadingAnchor.constraint(equalTo: date.trailingAnchor, constant: 5),
            separator.topAnchor.constraint(equalTo: context.bottomAnchor, constant: 5),
            
            category.topAnchor.constraint(equalTo: context.bottomAnchor, constant: 5),
            category.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 5),
            category.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }
    
    func setupCell(article: ArticleDB?) {
        
        guard let article = article else {
            return
        }
        
        title.text = article.title
        title.numberOfLines = 2
        title.textColor = .primaryStaticText
        title.font = UIFont.newsAppFont(ofSize: 18, weight: .bold)
        title.lineBreakMode = .byTruncatingTail
        
        context.text = article.articleDescription
        context.textAlignment = .left
        context.textColor = .primaryStaticText
        context.font = UIFont.newsAppFont(ofSize: 14, weight: .regular)
        context.numberOfLines = 3
        context.lineBreakMode = .byTruncatingTail
        
        date.text = formattedDateFromString(dateString: article.publishedAt ?? "")
        date.textColor = .primaryGray
        date.font = UIFont.newsAppFont(ofSize: 13, weight: .light)
        
        if let url = URL(string: article.urlToImage ?? "") {
            rightImage.load(url: url )
        }
    }
    
    //TODO: Move this somewhere more relevant
    
    private func formattedDateFromString(dateString: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" + "Z"

        if let date = inputFormatter.date(from: dateString) {

          let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = "MMM dd, yyyy"

            return outputFormatter.string(from: date)
        }
        return nil
    }
}

