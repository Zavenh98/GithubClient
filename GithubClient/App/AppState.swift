//
//  AppState.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 03.01.26.
//

import Foundation

@Observable
final class AppState {
    var appFlow: AppFlow
    
    init() {
        self.appFlow = KeychainAuthManager.shared.isAuthenticated ? .main : .login
    }
}
