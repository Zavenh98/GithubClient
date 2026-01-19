//
//  LoginViewModel.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

final class LoginViewModel {
    var login: String = "" { didSet { validateForm() } }
    var password: String = "" { didSet { validateForm() } }
    var onChangedLoading: ((Bool) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    var formValidationChanged: ((Bool) -> Void)?

    private let authorizationManager: AuthorizationManagerInput

    init(authorizationManager: AuthorizationManagerInput) {
        self.authorizationManager = authorizationManager
    }

    func signIn() {
        guard !login.isEmpty, !password.isEmpty else { return }
        
        Task { @MainActor in
            onChangedLoading?(true)
            do {
                try await authorizationManager.logIn(with: Credentials(login: login, token: password))
                onChangedLoading?(false)
                self.onLoginSuccess?()
            } catch {
                onChangedLoading?(false)
                if let _ = error as? KeychainError {
                    onLoginFailure?("Your credentials weren't acceptable.")
                    return
                }
                onLoginFailure?(error.localizedDescription)
            }
        }
    }
    
    private func validateForm() {
        let isValid = !login.isEmpty && !password.isEmpty
        formValidationChanged?(isValid)
    }
}
