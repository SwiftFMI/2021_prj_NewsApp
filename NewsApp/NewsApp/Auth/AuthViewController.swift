//
//  AuthViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 22.02.22.
//

import Foundation
import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    private enum ViewMode {
        case signIn, signUp
    }
    
    private var authViewMode: ViewMode = .signIn {
        didSet {
            updateViewMode()
        }
    }
    
    private let emailTextField = OvalTextField()
    private let passwordTextField = OvalTextField()
    private let confirmPasswordTextField = OvalTextField()
   
    private let buttonsContainer = UIView()
    private let toggleViewModeButton = UIButton()
    private let signInButton = UIButton()
    
    private let spinner = UIActivityIndicatorView()
    
    private var formButtonsTopAnchor = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackgrond
        
        configureUsernameTextField(emailTextField)
        configurePasswordTextField(passwordTextField)
        configurePasswordTextField(confirmPasswordTextField)
        configureTextButton(toggleViewModeButton)
        configureSendButton(signInButton)
        
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        confirmPasswordTextField.placeholder = "Confirm Password"
        
        signInButton.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        toggleViewModeButton.addTarget(self, action: #selector(toggleViewMode), for: .touchUpInside)
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo")?.resizeImage(width: 160)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.backgroundColor = .clear
        
        let formContainer = UIView()
        formContainer.translatesAutoresizingMaskIntoConstraints = false
        formContainer.backgroundColor = .clear
        
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.backgroundColor = .clear
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        formContainer.addSubview(emailTextField)
        formContainer.addSubview(passwordTextField)
        formContainer.addSubview(confirmPasswordTextField)
        formContainer.addSubview(buttonsContainer)
        formContainer.addSubview(spinner)
        
        buttonsContainer.addSubview(toggleViewModeButton)
        buttonsContainer.addSubview(signInButton)
        
        view.addSubview(logoImageView)
        view.addSubview(formContainer)
        
        let safeArea = view.safeAreaLayoutGuide
        
        formButtonsTopAnchor = buttonsContainer.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -100),
            
            formContainer.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            formContainer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            formContainer.widthAnchor.constraint(equalToConstant: 250),
            formContainer.heightAnchor.constraint(equalToConstant: 250),
            
            emailTextField.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor),
            emailTextField.topAnchor.constraint(equalTo: formContainer.topAnchor),
            emailTextField.widthAnchor.constraint(equalTo: formContainer.widthAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            passwordTextField.widthAnchor.constraint(equalTo: formContainer.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            confirmPasswordTextField.widthAnchor.constraint(equalTo: formContainer.widthAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            buttonsContainer.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            buttonsContainer.widthAnchor.constraint(equalTo: formContainer.widthAnchor),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 50),
            
            toggleViewModeButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            toggleViewModeButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor),
            toggleViewModeButton.widthAnchor.constraint(equalToConstant: 50),
            toggleViewModeButton.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            signInButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 50),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            spinner.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor),
        ])
        
        updateViewMode()
    }
    
    private func configureUsernameTextField(_ textField: UITextField) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.backgroundColor = .secondaryBackground
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 15
        
    }
    
    private func configurePasswordTextField(_ textField: UITextField) {
        configureUsernameTextField(textField)
        
        textField.isSecureTextEntry = true
    }
    
    private func configureSendButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SystemAssets.arrowUpCircleFill?.resizeImage(height: 35)?.withTintColor(.primaryHighlight), for: .normal)
        button.configuration = UIButton.Configuration.plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)
    }
   
    private func configureTextButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.primaryHighlight, for: .normal)
        button.titleLabel?.font = .newsAppFont(ofSize: 12)
    }
    
    @objc private func toggleViewMode() {
        authViewMode = authViewMode == .signIn ? .signUp : .signIn
    }
    
    private func updateViewMode() {
        switch authViewMode {
            
        case .signIn:
            toggleViewModeButton.setTitle("Sign Up.", for: .normal)
            confirmPasswordTextField.isHidden = true
            NSLayoutConstraint.deactivate([formButtonsTopAnchor])
            formButtonsTopAnchor = buttonsContainer.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5)
            NSLayoutConstraint.activate([formButtonsTopAnchor])
            
        case .signUp:
            toggleViewModeButton.setTitle("Sign In.", for: .normal)
            confirmPasswordTextField.isHidden = false
            NSLayoutConstraint.deactivate([formButtonsTopAnchor])
            formButtonsTopAnchor = buttonsContainer.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 5)
            NSLayoutConstraint.activate([formButtonsTopAnchor])
        }
        
        view.setNeedsLayout()
    }
    
    private func getFirstInvalidField() -> OvalTextField? {
        if emailTextField.text == nil || emailTextField.text == "" {
            return emailTextField
        }
        
        if passwordTextField.text == nil || passwordTextField.text == "" {
            return passwordTextField
        }
        
        if !confirmPasswordTextField.isHidden &&
            (confirmPasswordTextField.text == nil ||
             confirmPasswordTextField.text != passwordTextField.text) {
            return confirmPasswordTextField
        }
        
        return nil
    }
    
    @objc private func authenticate() {
        if let invalidField = getFirstInvalidField() {
            invalidField.shake()
            return
        }
        
        toggleSpinner(on: true)
        
        switch authViewMode {
        case .signIn:
            signIn()
        case .signUp:
            signUp()
        }
    }
    
    private func signIn() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { [weak self] (authResult, error) in
            self?.authUser(fromAuthResult: authResult, error: error)
        })
    }
    
    private func signUp() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] (authResult, error) in
            self?.authUser(fromAuthResult: authResult, error: error)
        }
    }
    
    private func authUser(fromAuthResult authResult: AuthDataResult?, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.toggleSpinner(on: false)
            
            guard let user = authResult?.user, error == nil else {
                NSLog("\(error)")
                return
            }
            
            AuthState.current.logIn(user)
            UserInfoManager.current.reloadUserInfo()
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func toggleSpinner(on: Bool) {
        if on {
            spinner.startAnimating()
            spinner.isHidden = false
            signInButton.isHidden = true
        } else {
            spinner.stopAnimating()
            spinner.isHidden = true
            signInButton.isHidden = false
        }
    }
}
