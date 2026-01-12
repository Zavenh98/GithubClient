//
//  KeychainServiceProtocol.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 10.01.26.
//

import Foundation

protocol KeychainServiceProtocol {
    var isAuthenticated: Bool { get }
    func setCredentials(credentials: Credentials) throws
    func getCredentials() throws -> Credentials
    func deleteCredentials() throws
}
