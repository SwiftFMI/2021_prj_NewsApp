//
//  AuthState.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 22.02.22.
//

import Foundation
import FirebaseAuth
import UIKit

class AuthState {
    static let current = AuthState()
    
    let userLoginStatus = UserDefaults.standard.bool(forKey: "isUserLogged")
    
    func logIn(_ user: User) {
        UserDefaults.standard.set(true, forKey: "isUserLogged")
    }
    
    func logOut(authControllerPresenter presenter: UIViewController) {
        UserDefaults.standard.set(false, forKey: "isUserLogged")
        
        RealmHelper.nuke()
        
        let authController = AuthViewController()
        authController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async {
            presenter.present(authController, animated: true, completion: nil)
        }
    }
}
