//
//  GithubClientApp.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 27.12.25.
//

import SwiftUI

@main
struct GithubClientApp: App {
    private let keychainManager = KeychainManager()
    @State private var appState: AppState

    init() {
        _appState = State(initialValue: AppState(keychainManager: keychainManager))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
