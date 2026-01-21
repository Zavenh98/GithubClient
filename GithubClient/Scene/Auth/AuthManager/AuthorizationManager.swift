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
    private let networkManager: NetworkManagerInput
    
    init(keychainManager: KeychainManagerInput, networkManager: NetworkManagerInput) {
        self.keychainManager = keychainManager
        self.networkManager = networkManager
    }
    
    func logIn(with credentials: Credentials) async throws {
        let request = LoginRequest(credentials: credentials)
        do {
            try await networkManager.request(request)
            try keychainManager.setCredentials(credentials: credentials)
        } catch {
            if let networkError = error as? NetworkError, networkError == NetworkError.unauthorized {
                throw credentialsError
            }
            throw error
        }
    }
}
