//
//  GithubClientApp.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 27.12.25.
//

import SwiftUI

@main
struct GithubClientApp: App {
    private let keychainService = KeychainService()
    @State private var appState: AppState

    init() {
        _appState = State(initialValue: AppState(keychainService: keychainService))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
