//
//  UIColorExtensions.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

extension UIColor {
    //TODO: also add our main colours here for all to use
    static let primaryBackgrond = UIColor(red: 249, green: 249, blue: 249)
    static let secondaryBackground = UIColor(red: 230, green: 230, blue: 230)
    static let primaryStaticText = UIColor.black
    static let primaryInteractiveText = UIColor.blue
    static let primaryHighlight = UIColor.orange
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
