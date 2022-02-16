//
//  PopoverMenuItem.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

struct PopoverMenuItem {
    let image: UIImage?
    let title: String
    let titleFont: UIFont
    let titleTextColor: UIColor
    let showAccessoryView: Bool
    let menuItemAction: (() -> Void)?
    
    init(image: UIImage? = nil, title: String, titleFont: UIFont = .newsAppFont(ofSize: 14), titleTextColor: UIColor = .primaryStaticText, showAccessoryView: Bool = false, menuItemAction: (() -> Void)?) {
        self.image = image
        self.title = title
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
        self.showAccessoryView = showAccessoryView
        self.menuItemAction = menuItemAction
    }
}
