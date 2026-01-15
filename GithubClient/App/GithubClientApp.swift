//
//  GithubClientApp.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 27.12.25.
//

import SwiftUI

@main
struct GithubClientApp: App {
    @State private var appState: AppState
    private let appEvironment: AppEnvironment
    
    init() {
        let environment = AppEnvironment()
        self.appEvironment = environment
        
        let hasCredentials = (try? environment.keychainManager.getCredentials()) != nil
        _appState = State(initialValue: AppState(isAuthenticated: hasCredentials))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(\.appEnvironment, appEvironment)
        }
    }
}
