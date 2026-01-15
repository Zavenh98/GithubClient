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
        return ZStack {
            switch appState.appFlow {
            case .login:
                LoginContainerView(
                    onLoginSuccess: { appState.appFlow = .main } )
            case .main:
                ZStack {
                    Color(.gray.opacity(0.2))
                    
                    Button("Logout") {
                        appState.appFlow = .login
                    }
                }
                .transition(.move(edge: .trailing))
            }
        }
        .background(.bgPrimary)
        .ignoresSafeArea(.container)
        .animation(.easeInOut(duration: 0.5), value: appState.appFlow)
    }
}

#Preview {
    ContentView()
        .environment(AppState(isAuthenticated: true))
}
