//
//  SeparatorView.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

/// Set top anchor and it's good to go.
class SeparatorView: UIView {
    init(parentView: UIView, color: UIColor, padding: CGFloat = 0) {
        super.init(frame: .zero)
        parentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = color
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 1),
            leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
