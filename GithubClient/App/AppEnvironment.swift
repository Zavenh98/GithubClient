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
    let networkManager: NetworkManagerInput

    init() {
        let keychainManager = KeychainManager()
        let reachabilityManager = ReachabilityManager()
        let networkManager = NetworkManager(
            keychainManager: keychainManager, reachablityManager: reachabilityManager)
        
        self.keychainManager = keychainManager
        self.networkManager = networkManager
    }
}
