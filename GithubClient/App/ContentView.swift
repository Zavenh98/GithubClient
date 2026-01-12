//
//  ContentView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 27.12.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        VStack {
            switch appState.appFlow {
            case .login:
                Text("Login Flow")
            case .main:
                Text("Main Flow")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(AppState(keychainManager: KeychainManager()))
}
