//
//  UIFontExtensions.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

extension UIFont {
    class func newsAppFont(ofSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        var fontName = "PlayfairDisplay-Regular"
        
        switch weight {
        case .bold:
            fontName = "PlayfairDisplay-Bold"
        case .light:
            fontName = "PlayfairDisplay-Regular"
        case .medium:
            fontName = "PlayfairDisplay-Medium"
        default:
            fontName = "PlayfairDisplay-Regular"
        }
        guard let font = UIFont(name: fontName, size: ofSize) else {
            return UIFont.systemFont(ofSize: ofSize, weight: weight)
        }
        
        return font
    }
}
