//
//  LoginViewController.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import UIKit
import SwiftUI

struct LoginContainerView: UIViewControllerRepresentable {
    @Environment(\.appEnvironment) private var appEnvironment
    let onLoginSuccess: () -> Void

    func makeUIViewController(context: Context) -> LoginViewController {
        let viewModel = LoginViewModel(
            authorizationManager: AuthorizationManager(
                keychainManager: appEnvironment.keychainManager,
                networkManager: appEnvironment.networkManager))
        
        viewModel.onLoginSuccess = { onLoginSuccess() }
        
        return LoginViewController(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {}
}

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordEyeButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    private let eyeImageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
    private let loadingView = UIKitLoadingView()
    private let viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindViewModel()
    }
    
        private func configureView() {
            loginTextField.layer.cornerRadius = 16
            loginTextField.layer.borderWidth = 1
            loginTextField.layer.borderColor = UIColor.textSecondary.cgColor
            loginTextField.layer.masksToBounds = true
            loginTextField.autocorrectionType = .no
            loginTextField.autocapitalizationType = .none
            loginTextField.keyboardType = .emailAddress
            loginTextField.returnKeyType = .next
            loginTextField.addTarget(self, action: #selector(loginTextDidChange), for: .editingChanged)
            loginTextField.delegate = self
            
            passwordTextField.layer.cornerRadius = 16
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.textSecondary.cgColor
            passwordTextField.layer.masksToBounds = true
            passwordTextField.autocorrectionType = .no
            passwordTextField.autocapitalizationType = .none
            passwordTextField.keyboardType = .emailAddress
            passwordTextField.returnKeyType = .go
            passwordTextField.isSecureTextEntry = true
            passwordTextField.addTarget(self, action: #selector(passwordTexDidChange), for: .editingChanged)
            passwordTextField.delegate = self
            
            passwordEyeButton.tintColor = .textSecondary
            passwordEyeButton.imageView?.contentMode = .scaleAspectFit
            passwordEyeButton.setImage(UIImage(systemName: "eye.slash", withConfiguration: eyeImageConfig),for: .normal)
            passwordEyeButton.addTarget(self, action: #selector(didTapPasswordEye), for: .touchUpInside)

            signInButton.layer.cornerRadius = 16
            signInButton.layer.masksToBounds = true
            signInButton.isEnabled = false
            signInButton.alpha = 0.7
            signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
            
            loadingView.frame = view.bounds
            view.addSubview(loadingView)
        }
    
    private func bindViewModel() {
        viewModel.formValidationChanged = { [weak self] isValid in
            self?.signInButton.isEnabled = isValid
            self?.signInButton.alpha = isValid ? 1.0 : 0.7
        }
        
        viewModel.onChangedLoading = { [weak self] isLoading in
            if isLoading {
                self?.loadingView.startAnimate()
            } else {
                self?.loadingView.stopAnimate()
            }
        }
        
        viewModel.onLoginFailure = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Ooops!",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Actions
    @objc private func didTapSignIn() {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        viewModel.signIn()
    }
    
    @objc private func didTapPasswordEye() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordEyeButton.setImage(UIImage(systemName: imageName, withConfiguration: eyeImageConfig), for: .normal)
    }
    
    @objc private func loginTextDidChange() {
        viewModel.login = loginTextField.text ?? ""
    }
    
    @objc private func passwordTexDidChange() {
        viewModel.password = passwordTextField.text ?? ""
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.brandMainPurple.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textSecondary.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
            return true
        }

        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            
            guard signInButton.isEnabled else { return false }
            viewModel.signIn()
            return true
        }
        
        return false
    }
}
