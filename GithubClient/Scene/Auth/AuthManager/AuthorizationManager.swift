//
//  AuthorizationManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

protocol AuthorizationManagerInput {
    func logIn(with credentials: Credentials) async throws
}

class AuthorizationManager: AuthorizationManagerInput {
    private let credentialsError = NetworkError(status: "Invalid credentials",
                                        errorCode: 401,
                                        message: "Username/email or password was wrong.")
    
    private let keychainManager: KeychainManagerInput
    private let defaultsStorsageManager: DefaultsStorageManagerInput
    private let networkManager: NetworkManagerInput
    
    init(
        keychainManager: KeychainManagerInput,
        defaultsStorsageManager: DefaultsStorageManagerInput,
        networkManager: NetworkManagerInput
    ) {
        self.keychainManager = keychainManager
        self.defaultsStorsageManager = defaultsStorsageManager
        self.networkManager = networkManager
    }
    
    func logIn(with credentials: Credentials) async throws {
        let request = LoginRequest(credentials: credentials)
        do {
            let response = try await networkManager.request(request) 
            try keychainManager.setCredentials(credentials: credentials)
            defaultsStorsageManager.set(response.login, for: .currentUserUsername)
        } catch {
            if let networkError = error as? NetworkError, networkError == NetworkError.unauthorized {
                throw credentialsError
            }
            throw error
        }
    }
}
