//
//  MusicPlayerViewModel.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 25.01.26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class MusicPlayerViewModel {
    var hasError: Bool = false 
    var errorMessage: String = ""
    
    var importedAudioFiles: [AudioFileItem] = []
    var cachedAudioFiles: [AudioFileItem] = []
    
    var currentAudio: AudioFileItem?
    var currentTime: TimeInterval = 0
    var isPlaying: Bool = false
    var isPlayedInitialAudio: Bool = false
    
    private var isSeeking: Bool = false
    private var lastPlayedIndex: Int?
    private var timer: Timer?
    
    private let audioFileManager: AudioFileManagerInput
    private let playbackManager: AudioPlaybackManagerInput
    
    // MARK: - Initialization
    init(
        audioFileManager: AudioFileManagerInput,
        playbackManager: AudioPlaybackManagerInput
    ) {
        self.audioFileManager = audioFileManager
        self.playbackManager = playbackManager
        
        self.playbackManager.onFinished = { [weak self] in
            guard let self else { return }
            self.playNext()
        }
        
        Task { await getCachedAudioFiles() }
    }
    
    // MARK: - Public methodes
    
    func playNewAudio(audioFile: AudioFileItem) {
        self.setAudio(audioFile: audioFile)
        self.play()
    }
    
    func togglePlaying() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func playPrevious() {
        guard let currentIndex = lastPlayedIndex, !cachedAudioFiles.isEmpty else { return }
        
        // Go backward when currentTime < 3, otherwise play same
        // Privent backwarding if current auido is first item of list
        let previousIndex = currentTime > 3 ? currentIndex : (currentIndex > 0 ? currentIndex - 1 : 0)
        self.setAudio(audioFile: cachedAudioFiles[previousIndex])
        self.invalidateTimer()
        self.currentTime = 0
        
        // Continue playing
        if isPlaying {
            play()
        }
    }
    
    func playNext() {
        guard let currentIndex = lastPlayedIndex, !cachedAudioFiles.isEmpty else { return }
        
        // Go to first if now is playing the last audio
        let nextIndex = currentIndex + 1 < cachedAudioFiles.count ? currentIndex + 1 : 0
        self.setAudio(audioFile: cachedAudioFiles[nextIndex])
        self.invalidateTimer()
        self.currentTime = 0
        
        // Pause if went to the first audio
        guard nextIndex != 0 else {
            pause()
            return
        }
        
        // Continue playing
        if isPlaying {
            play()
        }
    }
    
    func beginSeekIfNeeded() {
        if !isSeeking {
            isSeeking = true
        }
    }

    func endSeek() {
        playbackManager.seek(to: currentTime)
        
        // Observe currentTime value with a delay after seeking to privent slider unexpected behavior
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isSeeking = false
        }
    }
    
    // MARK: - Private methodes
    
    private func play() {
        playbackManager.play()
        startTimer()
        isPlaying = true
    }
    
    private func pause() {
        playbackManager.pause()
        invalidateTimer()
        isPlaying = false
    }
    
    private func setAudio(audioFile: AudioFileItem) {
        self.currentAudio = audioFile
        self.playbackManager.setAudio(url: audioFile.url)
        if let index = cachedAudioFiles.firstIndex(where: { $0 == currentAudio }) {
            self.lastPlayedIndex = index
        }
    }
    
    private func startTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                guard !self.isSeeking else { return }
                self.currentTime = self.playbackManager.currentTime
            }
        })
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Audiofile methodes
extension MusicPlayerViewModel {
    func getCachedAudioFiles() async {
        cachedAudioFiles = (try? await audioFileManager.getCachedAudioFiles()) ?? []
    }
    
    func importURLs(_ urls: [URL]) {
        Task {
            for url in urls {
                do {
                    let newAudioFile = try await audioFileManager.buildAudiofile(from: url)
                    if importedAudioFiles.contains(newAudioFile) {
                        errorMessage = "Audio file already imported: \(newAudioFile.title ?? newAudioFile.fileName)"
                        hasError = true
                    } else {
                        importedAudioFiles.append(newAudioFile)
                    }
                } catch {
                    if let error = error as? AudioFileError {
                        errorMessage = error.errorDescription ?? ""
                        hasError = true
                    }
                }
            }
        }
    }
    
    func cacheAndPlay(_ audioFile: AudioFileItem)  {
        Task {
            do {
                let cachedURL = try await audioFileManager.cacheAudioFile(audioFile)
                let cachedFile = AudioFileItem(url: cachedURL, title: audioFile.title, artist: audioFile.artist, artwork: audioFile.artwork, fileSize: audioFile.fileSize, duration: audioFile.duration)
                importedAudioFiles.removeAll(where: {$0 == audioFile})
                cachedAudioFiles.removeAll(where: {$0 == cachedFile})
                cachedAudioFiles.insert(cachedFile, at: 0)
                
                playNewAudio(audioFile: cachedFile)
            } catch {
                if let error = error as? AudioFileError {
                    errorMessage = error.errorDescription ?? ""
                    hasError = true
                }
            }
        }
    }
    
    func deleteImportedAudioFile(at offsets: IndexSet) {
        importedAudioFiles.remove(atOffsets: offsets)
    }
    
    func deleteCachedAudioFile(at offsets: IndexSet) {
        Task {
            for offset in offsets {
                let item = cachedAudioFiles[offset]
                try? await audioFileManager.deleteAudioFile(item)
            }
            cachedAudioFiles.remove(atOffsets: offsets)
        }
    }
}
