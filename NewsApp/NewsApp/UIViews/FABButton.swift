//
//  FABButton.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

/// A circular button that could preview an image that gets resized to fit in the circle.
/// Allows toggling it enabled/disabled via `setEnabledStyle(enabled:Bool)`
class FABButton: UIButton {
    init(with image: UIImage? = nil, and title: String? = nil, tintColor: UIColor = .systemBlue, font: UIFont = UIFont.newsAppFont(ofSize: 8, weight: .light)) {
        super.init(frame: .zero)
        
        configuration = Configuration.gray()
        configuration?.cornerStyle = .medium
        configuration?.imagePlacement = .top
        configuration?.buttonSize = .small
        
        setImage(image?.resizeImage(width: 30)?.withTintColor(tintColor), for: .normal)
        imageView?.maskCircle(image)
        
        setTitle(title, for: .normal)
        titleLabel?.textColor = tintColor
        titleLabel?.font = font
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEnabledStyle(enabled: Bool) {
        if enabled {
            self.alpha = 1
            self.isUserInteractionEnabled = true
        } else {
            self.alpha = 0.5
            self.isUserInteractionEnabled = false
        }
    }
}
