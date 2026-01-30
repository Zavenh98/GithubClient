//
//  NowPlayingView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 28.01.26.
//

import SwiftUI

struct NowPlayingView: View {
    @Binding var isExpanded: Bool
    @Namespace private var namespace
    @Bindable var viewModel: MusicPlayerViewModel
    
    var body: some View {
        if isExpanded {
            ExpandedPlayingView(
                isExpanded: $isExpanded,
                namespace: namespace,
                viewModel: viewModel)
        } else {
            MiniPlayingView(
                isExpanded: $isExpanded,
                namespace: namespace,
                viewModel: viewModel)
        }
    }
}

#Preview {
    NowPlayingView(
        isExpanded: .constant(false),
        viewModel: MusicPlayerViewModel(
            audioFileManager: AudioFileManager(
                fileStorage: FileStorageManager()),
            playbackManager: AudioPlaybackManager()
        )
    )
}
