//
//  ContentView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 27.12.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) var appState
    @AppStorage("appTheme") var appTheme = AppTheme.system
    
    var body: some View {
        ZStack {
            switch appState.appFlow {
            case .login:
                LoginContainerView(
                    onLoginSuccess: { appState.appFlow = .main } )
            case .main:
                MainFlowView()
                    .transition(.move(edge: .trailing))
            }
        }
        .background(.bgPrimary)
        .ignoresSafeArea(.container)
        .animation(.easeInOut(duration: 0.5), value: appState.appFlow)
        .preferredColorScheme(appTheme.colorScheme)
    }
}

#Preview {
    ContentView()
        .environment(AppState(isAuthenticated: true))
}
