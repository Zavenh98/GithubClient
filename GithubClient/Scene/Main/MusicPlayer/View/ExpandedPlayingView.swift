//
//  ExpandedPlayingView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 28.01.26.
//

import SwiftUI

struct ExpandedPlayingView: View {
    @Binding var isExpanded: Bool
    var namespace: Namespace.ID
    @Bindable var viewModel: MusicPlayerViewModel
    
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                background
                
                // Landscape state for iPhones
                let isSmallHeight =  size.height < 500
                
                VStack(spacing: isSmallHeight ? 4 : R.Offsets.common) {
                    presentationIndicator
                        .offset(y: animateContent ? 0 : size.height)
                    
                    if isSmallHeight {
                        HStack(spacing: R.Offsets.common) {
                            artworkImage(isSmallScreen: true)
                            
                            VStack(spacing: 4) {
                                titleAndArtist
                                timingSlider
                                playbackControls(height: size.height * 2.0)
                            }
                            .padding(.vertical, -40)
                            .offset(y: animateContent ? 0 : size.height)
                        }
                    } else {
                        VStack(spacing: R.Offsets.common) {
                            artworkImage(isSmallScreen: false)
                            
                            VStack(spacing: R.Offsets.common) {
                                titleAndArtist
                                timingSlider
                                playbackControls(height: size.height)
                            }
                            .padding(.horizontal, R.Offsets.commonPlus)
                            .offset(y: animateContent ? 0 : size.height)
                        }
                    }
                }
                .padding(.top, safeArea.top + R.Offsets.small)
                .padding(.bottom, safeArea.bottom + R.Offsets.common)
                .padding(.leading, safeArea.leading)
                .padding(.trailing, safeArea.trailing)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isSmallHeight ? .center : .top)
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .ignoresSafeArea(.container, edges: .all)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if offsetY > size.height * 0.3 {
                                isExpanded = false
                                animateContent = false
                            } else {
                                offsetY = 0
                            }
                        }
                    })
            )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Components
extension ExpandedPlayingView {
    private var background: some View {
        RoundedRectangle(cornerRadius: deviceCornerRadius)
            .fill(.bgPlaying)
            .shadow(color: .black.opacity(0.1), radius: 4)
            .opacity(animateContent ? 1 : 0)
            .matchedGeometryEffect(id: "background", in: namespace)
    }
    
    private var presentationIndicator: some View {
        Capsule().fill(.gray)
            .frame(width: 48, height: 6)
            .opacity(animateContent ? 1 : 0)
    }
    
    private func artworkImage(isSmallScreen: Bool) -> some View {
        ArtworkImage(image: viewModel.currentAudio?.artwork)
            .shadow(color: .black.opacity(0.15), radius: 6)
            .matchedGeometryEffect(
                id: "artwork",
                in: namespace)
            .padding(viewModel.isPlaying ? (isSmallScreen ? 8 : 16) : (isSmallScreen ? 32 : 72))
            .padding(.horizontal, 12)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.isPlaying)
    }
    
    private var titleAndArtist: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.currentAudio?.title ?? (viewModel.currentAudio?.fileName ?? ""))
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)
            Text(viewModel.currentAudio?.artist ?? "Unknown artist")
                .font(.callout)
                .foregroundStyle(.textSecondary)
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var timingSlider: some View {
        VStack(spacing: 8) {
            Slider(value: $viewModel.currentTime,
                   in: 0...(viewModel.currentAudio?.duration ?? 0.1)) { editing in
                if editing {
                    viewModel.beginSeekIfNeeded()
                } else {
                    viewModel.endSeek()
                }
            }
            
            HStack {
                Text(viewModel.currentTime.toMinuteSecond())
                Spacer()
                Text((viewModel.currentAudio?.duration ?? 0.1).toMinuteSecond())
            }
            .font(.caption)
            .foregroundStyle(.textSecondary)
        }
    }
    
    private func  playbackControls(height: CGFloat) -> some View {
            HStack {
                playbackControllButton(imageName: "backward.fill", height: height * 0.03) {
                    viewModel.playPrevious()
                }
                
                playbackControllButton(imageName: viewModel.isPlaying ? "pause.fill" : "play.fill", height: height * 0.06) {
                        viewModel.togglePlaying()
                }
                .offset(x: viewModel.isPlaying ? 0 : 3)
                
                playbackControllButton(imageName: "forward.fill", height: height * 0.03) {
                    viewModel.playNext()
                }
            }
            .foregroundStyle(.textPrimary)
    }
    
    private func playbackControllButton(imageName: String, height: CGFloat, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: height)
                .animation(nil, value: viewModel.isPlaying)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    ExpandedPlayingView(
        isExpanded: .constant(false),
        namespace: Namespace().wrappedValue,
        viewModel: MusicPlayerViewModel(
            audioFileManager: AudioFileManager(
                fileStorage: FileStorageManager()),
            playbackManager: AudioPlaybackManager()
        )
    )
}
