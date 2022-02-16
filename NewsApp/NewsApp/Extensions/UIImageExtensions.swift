//
//  UIImageExtensions.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(width: CGFloat) -> UIImage? {
        let ratio = width / size.width
        let newSize = CGSize(width: width, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func resizeImage(height: CGFloat) -> UIImage? {
        let ratio = height / size.height
        let newSize = CGSize(width: size.width * ratio, height: height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
