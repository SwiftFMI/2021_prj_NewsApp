//
//  UIViewControllerExtensions.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit
import SideMenu

extension UIViewController {
    var sideMenuController: SideMenuController? {
        return findSideMenuController(from: self)
    }

    fileprivate func findSideMenuController(from viewController: UIViewController) -> SideMenuController? {
        var sourceViewController: UIViewController? = viewController
        repeat {
            sourceViewController = sourceViewController?.parent
            if let sideMenuController = sourceViewController as? SideMenuController {
                return sideMenuController
            }
        } while (sourceViewController != nil)
        return nil
    }
    
    @objc func add(asChildViewController viewController: UIViewController, contentView: UIView?) {
        addChild(viewController)
        
        if let contentView = contentView {
            contentView.addSubview(viewController.view)
            
            viewController.view.frame = contentView.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            viewController.didMove(toParent: self)
        }
    }
    
    @objc func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        
        viewController.view.removeFromSuperview()
        
        viewController.removeFromParent()
    }
}
