//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import UIKit
import SideMenu

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let menuController = SideMenuViewController()
        menuController.view.backgroundColor = .secondaryBackground
        
        let dashboardViewController = DashboardViewController()
        let navigationController = ProjectNavigationController(rootViewController: dashboardViewController)
        
        menuController.delegate = navigationController
        let sideController = AnimatedSideMenuController(contentViewController: navigationController, menuViewController: menuController)
        
        SideMenuController.preferences.basic.shouldAutorotate = true
        SideMenuController.preferences.basic.direction = .right
        SideMenuController.preferences.basic.enablePanGesture = true
        
        sideController.modalPresentationStyle = .fullScreen
        
        window?.rootViewController = sideController
        window?.makeKeyAndVisible()
       
        showSignIn()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}

    private func showSignIn() {
        if AuthState.current.userLoginStatus {
            return
        }
        
        let authController = AuthViewController()
        authController.modalPresentationStyle = .fullScreen
        
        if let presentedController = window?.rootViewController?.presentedViewController {
            if type(of: presentedController) != AuthViewController.self {
                presentedController.present(authController, animated: false, completion: nil)
                return
            }
        }
        
        window?.rootViewController?.present(authController, animated: false, completion: nil)
    }
}

