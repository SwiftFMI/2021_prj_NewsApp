//
//  DiscoverNewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 22.02.22.
//

import Foundation
import UIKit

class DiscoverNewsCollectionViewCell: UICollectionViewCell {
    static var cellIdentifier = "imageCell"
    
    private var logo = UIImageView()
    private var name = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(sourceData: Source) {
        logo.image = UIImage(imageLiteralResourceName: sourceData.image)
        name.text = sourceData.name
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6.0
        contentView.layer.masksToBounds = true
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFill
        logo.clipsToBounds = true
        contentView.addSubview(logo)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .center
        name.textColor = .black
        name.font = UIFont.newsAppFont(ofSize: 13, weight: .medium)
        contentView.addSubview(name)
    }
   
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            logo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            logo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            logo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            logo.widthAnchor.constraint(equalToConstant: 70),
            logo.heightAnchor.constraint(equalToConstant: 70),
            name.topAnchor.constraint(equalTo: logo.bottomAnchor),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

