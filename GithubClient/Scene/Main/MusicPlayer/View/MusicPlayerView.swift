//
//  MusicPlayerView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI
import UniformTypeIdentifiers

struct MusicPlayerView: View {
    @State private var isShownFileImporter: Bool = false
    @State private var isExpandedNowPlaying: Bool = false
    @State private var viewModel: MusicPlayerViewModel
    
    init(viewModel: MusicPlayerViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            listContent
                .overlay(alignment: .bottom) {
                    if viewModel.currentAudio != nil {
                        NowPlayingView(
                            isExpanded: $isExpandedNowPlaying,
                            viewModel: viewModel)
                    }
                }
                .overlay(alignment: .top) {
                    if viewModel.hasError && !viewModel.errorMessage.isEmpty {
                        toastBanner
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .animation(.default, value: viewModel.hasError)
                .navigationTitle("Music player")
                .navigationBarTitleDisplayMode(.inline)
            
            // Toolbar
                .toolbar {
                    if !isExpandedNowPlaying {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Import") {
                                isShownFileImporter = true
                            }
                            .fileImporter(
                                isPresented: $isShownFileImporter,
                                allowedContentTypes: [.audio, .mp3, .mpeg4Audio, .wav, .aiff],
                                allowsMultipleSelection: true) { result in
                                    switch result {
                                    case .success(let urls):
                                        viewModel.importURLs(urls)
                                    case .failure(let error):
                                        print("Import failed:", error)
                                    }
                                }
                        }
                        
                        ToolbarItem(placement: .topBarLeading) {
                            EditButton()
                        }
                    }
                }
        }
    }
}

// MARK: - Components
extension MusicPlayerView {
    private var listContent: some View {
        List {
            // MARK: - Empty list
            if viewModel.cachedAudioFiles.isEmpty, viewModel.importedAudioFiles.isEmpty  {
                ContentUnavailableView("There is no audio yet.",
                    systemImage: "music.note",
                    description: Text("Please import audio files to play them.")
                )
                .listRowBackground(Color.bgSecondary)
            } else {
                // MARK: - Imported files
                if !viewModel.importedAudioFiles.isEmpty {
                    Section("Need to cache") {
                        ForEach(viewModel.importedAudioFiles) { audio in
                            Button {
                                viewModel.cacheAndPlay(audio)
                            } label: {
                                AudioCell(audio: audio)
                                    .frame(height: 48)
                            }
                        }
                        .onDelete(perform: viewModel.deleteImportedAudioFile(at:))
                    }
                    .listRowBackground(Color.bgSecondary)
                }
                
                // MARK: - Cached files
                if !viewModel.cachedAudioFiles.isEmpty {
                    Section("Cached Files") {
                        ForEach(viewModel.cachedAudioFiles) { audio in
                            Button {
                                viewModel.playNewAudio(audioFile: audio)
                            } label: {
                                AudioCell(audio: audio)
                                    .frame(height: 48)
                            }
                        }
                        .onDelete(perform: viewModel.deleteCachedAudioFile(at:))
                    }
                    .listRowBackground(Color.bgSecondary)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.bgPrimary)
    }
        
    private var toastBanner: some View {
        Text(viewModel.errorMessage)
            .font(.subheadline)
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.black.opacity(0.8))
            }
            .padding(.horizontal)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    viewModel.errorMessage = ""
                    viewModel.hasError = false
                }
            }
    }
}

#Preview {
    MusicPlayerView(
        viewModel: MusicPlayerViewModel(
            audioFileManager: AudioFileManager(
                fileStorage: FileStorageManager()),
            playbackManager: AudioPlaybackManager()
        )
    )
}
