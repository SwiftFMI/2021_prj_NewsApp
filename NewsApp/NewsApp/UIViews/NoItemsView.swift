//
//  NoItemsView.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

/// A reusable view that notifies the user that no items are visible. Made to be used in cojuction with a UITableView that could sometimes be empty.
/// Toggle `.isHidden` between this and the UITableView. Shows a vertical stack of an optional image, a header, an optional description and an optional text button.
/// If a button is needed, pass the tap handler manually from outside to `createItemButton`.
class NoItemsView: UIView {
    let createItemButton = UIButton(type: .system)
    let headerLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageView = UIImageView()

    var buttonWidthAnchor: NSLayoutConstraint?
    
    init(image: UIImage?, header: String, description: String?, buttonTitle: String?, imageOnTop: Bool = true) {
        super.init(frame: CGRect.zero)

        translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
//        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        if imageOnTop {
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        } else {
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            ])
        }

        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.newsAppFont(ofSize: 20, weight: .regular)
        headerLabel.textColor = .white
        headerLabel.text = header

        if imageOnTop {
            headerLabel.textAlignment = .center
            NSLayoutConstraint.activate([
                headerLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
                headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
                headerLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 24),
                headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }

        if let description = description {
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

            addSubview(descriptionLabel)

            descriptionLabel.font = UIFont.newsAppFont(ofSize: 12)
            descriptionLabel.text = description
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textColor = .primaryStaticText
            descriptionLabel.accessibilityIdentifier = "noitemsdesc"

            if imageOnTop {
                descriptionLabel.textAlignment = .center
                NSLayoutConstraint.activate([
                    descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4),
                    descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                    descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])

                if buttonTitle == nil {
                    descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
                }
            } else {
                NSLayoutConstraint.activate([
                    descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 16),
                    descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 24),
                    descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            }
        }
        
        if let buttonTitle = buttonTitle {
            createItemButton.translatesAutoresizingMaskIntoConstraints = false
            createItemButton.setTitle(buttonTitle, for: .normal)
//            createItemButton.setFocusedStyle()
            
            addSubview(createItemButton)
            
            buttonWidthAnchor = createItemButton.widthAnchor.constraint(equalToConstant: 192)
            buttonWidthAnchor?.isActive = true
            
            NSLayoutConstraint.activate([
                createItemButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
                createItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                createItemButton.topAnchor.constraint(equalTo: description == nil ? headerLabel.bottomAnchor : descriptionLabel.bottomAnchor, constant: 10),
                createItemButton.heightAnchor.constraint(equalToConstant: 40),
            ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

