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
    
    let audioFileManager: AudioFileManagerInput
    
    init(audioFileManager: AudioFileManagerInput) {
        self.audioFileManager = audioFileManager
        Task { await getCachedAudioFiles() }
    }
    
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
                let cached = try await audioFileManager.cacheAudioFile(audioFile)
                let cachedFile = AudioFileItem(url: cached, title: audioFile.title, artist: audioFile.artist, artwork: audioFile.artwork, fileSize: audioFile.fileSize, duration: audioFile.duration)
                importedAudioFiles.removeAll(where: {$0 == audioFile})
                cachedAudioFiles.removeAll(where: {$0 == cachedFile})
                cachedAudioFiles.insert(cachedFile, at: 0)
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
