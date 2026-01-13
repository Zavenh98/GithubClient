//
//  KeychainManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 09.01.26.
//

import Foundation

final class KeychainManager: KeychainManagerInput {
    private let service = "githubclient.auth.credentials"
    
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
    
    func getCredentials() throws -> Credentials {
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
        
        guard let dictionary = item as? [String: Any],
              let login = dictionary[kSecAttrAccount as String] as? String,
              let passwordData = dictionary[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8)
        else {
            throw KeychainError.invalidData
        }
        print("Keychain item recived successfully")
        return Credentials(login: login, token: password)
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
