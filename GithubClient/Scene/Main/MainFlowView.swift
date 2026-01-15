//
//  MainFlowView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct MainFlowView: View {
    
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
            
            ProfileView()
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
