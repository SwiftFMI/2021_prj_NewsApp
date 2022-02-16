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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.backgroundEffect = UIBlurEffect(style: .dark)

            
        let scrollingAppearance = UINavigationBarAppearance()
        scrollingAppearance.configureWithTransparentBackground()
        scrollingAppearance.backgroundColor = .primaryBackgrond
            
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = scrollingAppearance
        UINavigationBar.appearance().compactAppearance = scrollingAppearance
        
        let menuController = SideMenuViewController()
        menuController.view.backgroundColor = .primaryBackgrond
        
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

    func showSignIn() {}
}

