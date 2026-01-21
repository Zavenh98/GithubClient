//
//  AppEnvironment.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var appEnvironment: AppEnvironment = AppEnvironment()
}

final class AppEnvironment {
    let keychainManager: KeychainManagerInput
    let defaultsStorageManager: DefaultsStorageManagerInput
    let fileStoregeManager: FileStorageManager
    let networkManager: NetworkManagerInput

    init() {
        let keychainManager = KeychainManager()
        let defaultsStorageManager = DefaultsStorageManager()
        let fileStoregeManager = FileStorageManager()
        let reachabilityManager = ReachabilityManager()
        let networkManager = NetworkManager(
            keychainManager: keychainManager, reachablityManager: reachabilityManager)
        
        self.keychainManager = keychainManager
        self.defaultsStorageManager = defaultsStorageManager
        self.fileStoregeManager = fileStoregeManager
        self.networkManager = networkManager
    }
}
