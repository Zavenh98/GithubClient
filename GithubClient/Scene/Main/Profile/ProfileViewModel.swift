//
//  ProfileViewModel.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import Foundation

@Observable
final class ProfileViewModel {
    var appState: AppState? = nil
    private let keychainmanager: KeychainManagerInput
    
    init(keychainmanager: KeychainManagerInput) {
        self.keychainmanager = keychainmanager
    }
    
    func logOut() {
        try? keychainmanager.deleteCredentials()
        appState?.appFlow = .login
    }
}
