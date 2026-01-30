//
//  MiniPlayingView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 28.01.26.
//

import SwiftUI

struct MiniPlayingView: View {
    @Binding var isExpanded: Bool
    var namespace: Namespace.ID
    @Bindable var viewModel: MusicPlayerViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ArtworkImage(image: viewModel.currentAudio?.artwork)
                .matchedGeometryEffect(id: "artwork", in: namespace)
                .padding(R.Offsets.commonMinus)
            
            Text(viewModel.currentAudio?.title ?? (viewModel.currentAudio?.fileName ?? ""))
                    .font(.headline)
                    .foregroundStyle(.textPrimary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                var transition = Transaction()
                transition.disablesAnimations = true
                withTransaction(transition) {
                    viewModel.togglePlaying()
                }
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title)
                    .foregroundStyle(.textPrimary)
                    .offset(x: viewModel.isPlaying ? 0 : 1)
            }
            .padding(.trailing, R.Offsets.commonPlus)
            .padding(.leading, R.Offsets.small)
        }
        .frame(height: 70)
        .background {
            RoundedRectangle(cornerRadius: R.Corners.regular)
                .fill(.bgPlaying)
                .shadow(color: .black.opacity(0.1), radius: 4)
                .matchedGeometryEffect(id: "background", in: namespace)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded = true
            }
        }
        .padding(R.Offsets.commonMinus)
        .onAppear() {
            if !viewModel.isPlayedInitialAudio {
                viewModel.isPlayedInitialAudio = true
                withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
                    isExpanded = true
                }
            }
        }
    }
}

#Preview {
    MiniPlayingView(
        isExpanded: .constant(false),
        namespace: Namespace().wrappedValue,
        viewModel: MusicPlayerViewModel(
            audioFileManager: AudioFileManager(
                fileStorage: FileStorageManager()),
            playbackManager: AudioPlaybackManager()
        ))
}
