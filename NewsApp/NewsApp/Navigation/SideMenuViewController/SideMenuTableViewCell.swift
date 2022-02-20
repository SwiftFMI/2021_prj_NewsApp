//
//  SideMenuTableViewCell.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    let sectionLabel = UILabel()
    var iconView = UIImageView()
    
    static let identifier = "SideMenuTableViewCellID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .secondaryBackground
        
        setUpIconView()
        setUpSectionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpIconView() {
        contentView.addSubview(iconView)
        iconView.contentMode = .center
        
        let paddingTopBottom: CGFloat = 12
        let paddingLeft: CGFloat = 21
        let widthHeight: CGFloat = 24
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: widthHeight),
            iconView.widthAnchor.constraint(equalToConstant: widthHeight),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: paddingTopBottom),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingTopBottom),
            iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: paddingLeft)
        ])
    }
    
    func setUpSectionLabel() {
        sectionLabel.font = UIFont.newsAppFont(ofSize: 14, weight: .medium)
        sectionLabel.textColor = UIColor.primaryInteractiveText
        
        contentView.addSubview(sectionLabel)
        
        let paddingTopBottom: CGFloat = 16
        let paddingLeft: CGFloat = 4
        
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: paddingTopBottom),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingTopBottom),
            sectionLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: paddingLeft)
        ])
    }
    
    func setUpWith(title: String, image: UIImage?, tintColor: UIColor) {
        sectionLabel.text = title
        sectionLabel.textColor = tintColor
        
        iconView.image = image?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = tintColor
    }
}
