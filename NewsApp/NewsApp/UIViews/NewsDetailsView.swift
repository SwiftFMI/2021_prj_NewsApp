//
//  NewsDetailsView.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 20.02.22.
//

import Foundation
import UIKit

protocol NewsDetailsViewDelegate: AnyObject {
    func newsDetailsViewDelegate(didTapOpenFullButton newsDetailsView: NewsDetailsView)
    func newsDetailsViewDelegate(didTapSaveButton newsDetailsView: NewsDetailsView)
}

class NewsDetailsView: UIView {
    private let posterImageView = UIImageView()
    private let dateLabel = UILabel()
    private let toggleFavouriteButton = FABButton()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let articleContentLabel = UILabel()
    private let openFullButton = UIButton()
    private let sourceLabel = UILabel()
    private let sourceUrlLabel = UILabel()
    

    private var isArticleFavourite: Bool
    
    weak var interactionDelegate: NewsDetailsViewDelegate?
    
    init(isArticleFavourite: Bool?) {
        self.isArticleFavourite = isArticleFavourite ?? false
        
        super.init(frame: .zero)
       
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .primaryBackgrond
        
        configureImageView(posterImageView)
        configureDateLabel(dateLabel)
        configureFavouriteButton(toggleFavouriteButton)
        configureTitleLabel(titleLabel)
        configureSecondaryStyleLabel(authorLabel)
        configureContentLabel(articleContentLabel)
        configureTextButton(openFullButton)
        configureSecondaryStyleLabel(sourceLabel)
        
        toggleFavouriteButton.addTarget(self, action: #selector(saveArticle), for: .touchUpInside)
        openFullButton.addTarget(self, action: #selector(openFull), for: .touchUpInside)
        
        addSubview(posterImageView)
        addSubview(dateLabel)
        addSubview(toggleFavouriteButton)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(articleContentLabel)
        addSubview(openFullButton)
        addSubview(sourceLabel)
        
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            toggleFavouriteButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            toggleFavouriteButton.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -10),
            
            dateLabel.centerYAnchor.constraint(equalTo: toggleFavouriteButton.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 10),
            
            titleLabel.topAnchor.constraint(equalTo: toggleFavouriteButton.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            
            articleContentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 25),
            articleContentLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            articleContentLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            
            openFullButton.topAnchor.constraint(equalTo: articleContentLabel.bottomAnchor, constant: 5),
            openFullButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            
            sourceLabel.topAnchor.constraint(equalTo: openFullButton.bottomAnchor, constant: 15),
            sourceLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            
            bottomAnchor.constraint(equalTo: sourceLabel.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func openFull() {
        interactionDelegate?.newsDetailsViewDelegate(didTapOpenFullButton: self)
    }
    
    @objc private func saveArticle() {
        interactionDelegate?.newsDetailsViewDelegate(didTapSaveButton: self)
    }
    
    private func configureImageView(_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTitleLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryStaticText
        label.font = .newsAppFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
    }
    
    private func configureContentLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryStaticText
        label.font = .newsAppFont(ofSize: 14)
        label.numberOfLines = 0
    }
    
    private func configureSecondaryStyleLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryStaticText
        label.font = .newsAppFont(ofSize: 14)
        label.numberOfLines = 0
    }
    
    private func configureDateLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryGray
        label.font = .newsAppFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
    }
    
    private func configureFavouriteButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        
        setFavouriteButtonStyle()
    }
    
    private func configureTextButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.primaryInteractiveText, for: .normal)
        button.titleLabel?.font = .newsAppFont(ofSize: 14)
    }
    
    func setArticle(_ article: ArticleDB?, withPosterImage image: UIImage?) {
        guard let article = article else {
            return
        }
        
        posterImageView.image = image?.resizeImage(height: 250)
        dateLabel.text = Date.formattedDateFromString(dateString: article.publishedAt ?? "")
        titleLabel.text = article.title
        authorLabel.text = article.author
        articleContentLabel.text = article.articleDescription
        sourceLabel.text = article.getSource()?.rawValue
        openFullButton.setTitle("Open full in browser.", for: .normal)
        toggleFavouriteButton.isHidden = false
    }
    
    func toggleFavouriteButtonStyle() {
        isArticleFavourite.toggle()
        setFavouriteButtonStyle()
    }
    
    private func setFavouriteButtonStyle() {
        isArticleFavourite ?
        toggleFavouriteButton.setImage(SystemAssets.heartFill?.resizeImage(width: 30)?.withTintColor(.black), for: .normal) :
        toggleFavouriteButton.setImage(SystemAssets.heart?.resizeImage(width: 30)?.withTintColor(.black), for: .normal)
    }
}
