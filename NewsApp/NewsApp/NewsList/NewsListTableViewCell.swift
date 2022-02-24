//
//  NewsListTableViewCell.swift
//  NewsApp
//
//  Created by Ivaylo Atovski on 20.02.22.
//

import Foundation
import UIKit

class NewsListTableViewCell : UITableViewCell{
    var newsImage = UIImageView()
    var newsTitle = UILabel()
    var newsDate  = UILabel()
    var newsInfo   = UILabel()
    
    static let identifier = "NewsItemTableViewCellID"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .secondaryBackground
        
        configureImage(newsImage)
        configureTitileLabel(newsTitle)
        configureDateLabel(newsDate)
        configureInfoLabel(newsInfo)
        
        contentView.addSubview(newsImage)
        contentView.addSubview(newsTitle)
        contentView.addSubview(newsDate)
        contentView.addSubview(newsInfo)

        NSLayoutConstraint.activate([
            
            newsImage.topAnchor.constraint(equalTo: topAnchor),
            newsImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImage.bottomAnchor.constraint(equalTo: centerYAnchor),
            
            newsTitle.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 5),
            newsTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            newsTitle.widthAnchor.constraint(equalToConstant: (frame.width * (7/8) )),
            newsTitle.heightAnchor.constraint(equalToConstant: 50),
            
            newsDate.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 5),
            newsDate.leftAnchor.constraint(equalTo: newsTitle.rightAnchor, constant: 5),
            newsDate.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            newsInfo.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: -10),
            newsInfo.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            newsInfo.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            newsInfo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20),
            newsInfo.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureTitileLabel(_ title : UILabel){
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.newsAppFont(ofSize: 18, weight: .bold)
        title.textColor = .primaryStaticText
        title.numberOfLines = 3
        title.lineBreakMode = .byTruncatingTail
    }
    
    private func configureDateLabel(_ dtateLabel : UILabel){
        dtateLabel.translatesAutoresizingMaskIntoConstraints = false
        dtateLabel.font             = UIFont.newsAppFont(ofSize: 10, weight: .light)
        dtateLabel.textColor        = .primaryGray
    }
    
    private func configureInfoLabel(_ infoLabel : UILabel){
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font             = UIFont.newsAppFont(ofSize: 12, weight: .medium)
        infoLabel.textColor        = UIColor.primaryStaticText
        infoLabel.numberOfLines    = 3
        infoLabel.lineBreakMode    = .byTruncatingTail
        infoLabel.textAlignment    = .justified
    }
    
    private func configureImage(_ image : UIImageView){
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(article: ArticleDB?) {
        
        guard let article = article else {
            return
        }
        
        newsTitle.text = article.title
        newsInfo.text = article.articleDescription
        
        newsDate.text = Date.formattedDateFromString(dateString: article.publishedAt ?? "")
        
        NewsAPISyncer().getImage(forUrl: article.urlToImage, completion: { [weak self] image in
            self?.newsImage.image = image
        })
    }
}
