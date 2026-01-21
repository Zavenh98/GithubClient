//
//  MainFlowView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct MainFlowView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    
    var body: some View {
        TabView {
            MyRepositoriesView()
                .tabItem {
                    Label("Repos", systemImage: "folder")
                }
            
            AllUsersView()
                .tabItem {
                    Label("Users", systemImage: "person.2")
                }
            
            MusicPlayerView()
                .tabItem {
                    Label("Music", systemImage: "music.note")
                }
            
            ProfileView(
                viewModel: ProfileViewModel(
                    keychainmanager: appEnvironment.keychainManager))
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .tint(.brandMainPurple)
    }
}

#Preview {
    MainFlowView()
}
