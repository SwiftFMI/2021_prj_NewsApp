//
//  UIColorExtensions.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

extension UIColor {
    static let primaryBackgrond = UIColor(red: 249, green: 249, blue: 249)
    static let secondaryBackground = UIColor(red: 230, green: 230, blue: 230)
    static let primaryStaticText = UIColor.black
    static let secondaryStaticText = UIColor.gray
    static let primaryInteractiveText = UIColor.blue
    static let secondaryGray = UIColor(red: 204, green: 204, blue: 204) //light grey
    static let primaryGray = UIColor(red: 153 , green: 153, blue: 153) //dark grey
    static let primaryHighlight = UIColor(red: 255, green: 117, blue: 24) // orange
    static let secondaryHighlight = UIColor(red: 255, green: 198, blue: 93) //light orange
        
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
