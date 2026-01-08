//
//  KeychainAuthManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 09.01.26.
//

import Foundation

struct Credentials {
    let login: String
    let token: String
}

final class KeychainAuthManager {
    static let shared = KeychainAuthManager()
    private let service = "com.githubclient.auth.credentials"
    private init() {}
    
    var isAuthenticated: Bool {
        do {
            try getCredentials()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func setCredentials(credentials: Credentials) throws {
        try? deleteCredentials()
        
        let account = credentials.login
        let password = credentials.token.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: password]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw convertError(status)
        }
        print("Keychain item saved successfully")
    }
    
    func getCredentials() throws {
        // TODO: - Remove unnecessary attributes if needed
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw convertError(status)
        }
        print("Keychain item recived successfully")
    }
    
    func deleteCredentials() throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess  else { throw convertError(status) }
        print("Keychain item deleted successfully")
    }
    
    private func convertError(_ status: OSStatus) -> KeychainError {
       switch status {
       case errSecDataTooLarge:
           return .invalidData
       case errSecItemNotFound:
          return .itemNotFound
       case errSecDuplicateItem:
          return .duplicateItem
       default:
          return .unexpectedError(status: status)
       }
    }
}

// MARK: - Keychain Error
extension KeychainAuthManager {
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
}
