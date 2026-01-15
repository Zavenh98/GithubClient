//
//  MusicPlayerView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct MusicPlayerView: View {
    
    var body: some View {
        NavigationStack {
            Color.green.opacity(0.3)
                .ignoresSafeArea()
                .navigationTitle("Music player")
        }
    }
}

#Preview {
    MusicPlayerView()
}
