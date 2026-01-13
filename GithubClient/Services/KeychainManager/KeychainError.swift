//
//  KeychainError.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 10.01.26.
//

import Foundation

enum KeychainError: LocalizedError {
    case invalidData
    case itemNotFound
    case duplicateItem
    case unexpectedError(status: OSStatus)
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid data for keychain"
        case .itemNotFound:
            return "Keychain item not found"
        case .duplicateItem:
            return "Keychain item already exist"
        case .unexpectedError(let status):
            return "Unexpected keychain error - \(status)"
        }
    }
}
