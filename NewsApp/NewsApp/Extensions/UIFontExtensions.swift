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
        // TODO: example font, change with whatever we choose to use
        var fontName = "SFUI-Regular"
        switch weight {
        case .bold:
            fontName = "SFUI-Bold"
        case .light:
            fontName = "SFUI-Light"
        case .medium:
            fontName = "SFUI-Medium"
        default:
            fontName = "SFUI-Regular"
        }
        guard let font = UIFont(name: fontName, size: ofSize) else {
            return UIFont.systemFont(ofSize: ofSize, weight: weight)
        }
        
        return font
    }
}
