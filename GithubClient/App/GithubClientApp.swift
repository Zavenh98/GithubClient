//
//  GithubClientApp.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 27.12.25.
//

import SwiftUI

@main
struct GithubClientApp: App {
    @State var appState: AppState = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
