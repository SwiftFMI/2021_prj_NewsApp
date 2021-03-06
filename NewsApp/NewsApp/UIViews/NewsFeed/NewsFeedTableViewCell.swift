//
//  NewsFeedTableViewCell.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 22.02.22.
//

import Foundation
import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NewsFeedTableViewCellID"
    
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
        
        date.text = Date.formattedDateFromString(dateString: article.publishedAt ?? "")
        date.textColor = .primaryGray
        date.font = UIFont.newsAppFont(ofSize: 13, weight: .light)
        
        NewsAPISyncer().getImage(forUrl: article.urlToImage, completion: { [weak self] image in
            self?.rightImage.image = image
        })
    }
}

