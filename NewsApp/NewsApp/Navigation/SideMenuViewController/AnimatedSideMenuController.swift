//
//  AnimatedSideMenuController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import SideMenu

class AnimatedSideMenuController: SideMenuController {
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard self.isMenuRevealed else {
            super.viewWillTransition(to: size, with: coordinator)
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.revealMenu(animated: false, completion: nil)
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
        
    }
}
