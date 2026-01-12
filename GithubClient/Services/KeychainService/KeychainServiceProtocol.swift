//
//  KeychainManagerInput.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 10.01.26.
//

import Foundation

protocol KeychainManagerInput {
    func setCredentials(credentials: Credentials) throws
    func getCredentials() throws -> Credentials
    func deleteCredentials() throws
}
