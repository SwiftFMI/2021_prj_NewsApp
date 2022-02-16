//
//  PopoverTableViewCell.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

class PopoverTableViewCell: UITableViewCell {

    let sectionLabel = UILabel()
    let iconView = UIImageView()

    static let identifier = "PopoverTableViewCellID"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .primaryBackgrond
        selectionStyle = .none

        setUpIconView()
        setUpSectionLabel()

        contentView.addSubview(iconView)
        contentView.addSubview(sectionLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpWith(menuItem: PopoverMenuItem) {
        self.sectionLabel.text = menuItem.title
        self.sectionLabel.font = menuItem.titleFont
        self.sectionLabel.textColor = menuItem.titleTextColor
        self.iconView.maskCircle(menuItem.image)

        setupConstraints()
    }

    private func setUpIconView() {
        iconView.contentMode = .center
        iconView.tintColor = .primaryHighlight
        iconView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setUpSectionLabel() {
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.deactivate(constraints)

        if iconView.image == nil {
            NSLayoutConstraint.activate([
                sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                sectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                iconView.heightAnchor.constraint(equalToConstant: 15),
                iconView.widthAnchor.constraint(equalToConstant: 15),
                iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                sectionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            ])
        }
    }
}
