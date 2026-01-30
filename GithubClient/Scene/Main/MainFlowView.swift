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
            MyRepositoriesView(
                viewModel: MyRepositoriesViewModel(
                    myRepositoriesManager: MyRepositoriesManager(
                        defaultsStorageManager: appEnvironment.defaultsStorageManager,
                        networkManager: appEnvironment.networkManager)))
            .tabItem {
                Label("Repos", systemImage: "folder")
            }
            
            AllUsersView(
                viewModel: AllUsersViewModel(
                    allUsersManager: AllUsersManager(
                        defaultsStorsageManager: appEnvironment.defaultsStorageManager,
                        networkManager: appEnvironment.networkManager)))
            .tabItem {
                Label("Users", systemImage: "person.2")
            }
            
            MusicPlayerView(
                viewModel: MusicPlayerViewModel(
                    audioFileManager: appEnvironment.audioFileManager,
                    playbackManager: appEnvironment.audioPlaybackManager))
            .tabItem {
                Label("Music", systemImage: "music.note")
            }
            
            ProfileView(
                viewModel: ProfileViewModel(
                    keychainManager: appEnvironment.keychainManager,
                    defaultsManager: appEnvironment.defaultsStorageManager,
                    fileStorageManager: appEnvironment.fileStoregeManager))
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
