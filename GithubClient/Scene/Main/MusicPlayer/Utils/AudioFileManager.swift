//
//  AudioFileManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 25.01.26.
//

import AVFoundation
import Foundation
import UIKit

protocol AudioFileManagerInput {
    func getCachedAudioFiles() async throws -> [AudioFileItem]
    func buildAudiofile(from url: URL) async throws -> AudioFileItem
    func cacheAudioFile(_ audioFile: AudioFileItem) async throws -> URL
    func deleteAudioFile(_ audioFile: AudioFileItem) async throws
}

final class AudioFileManager: AudioFileManagerInput {
    private let cachedAudioFolderName: String = "Audios"
    private let fileStorage: FileStorageManager
    
    init(fileStorage: FileStorageManager) {
        self.fileStorage = fileStorage
    }
    
    func getCachedAudioFiles() async throws -> [AudioFileItem] {
        var audioFiles: [AudioFileItem] = []
        let urls = try await fileStorage.loadURLs(in: cachedAudioFolderName)
        for url in urls {
            audioFiles.append(try await self.buildAudiofile(from: url))
        }
        
        return audioFiles
    }
    
    func buildAudiofile(from url: URL) async throws -> AudioFileItem {
        let didStartAccess = url.startAccessingSecurityScopedResource()
        defer { if didStartAccess { url.stopAccessingSecurityScopedResource() } }
        
        var audioFile = AudioFileItem(url: url)
        let asset = AVURLAsset(url: url)
        do {
            // Duration
            let cmTimeDurationn = try await asset.load(.duration)
            let seconds = CMTimeGetSeconds(cmTimeDurationn)
            audioFile.duration = seconds.isFinite ? seconds : nil
            
            // File size
            let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey])
            if let size = resourceValues.fileSize {
                audioFile.fileSize = size.bytesFormat()
            }
            
            let items = try await asset.load(.commonMetadata)
            
            // Title
            if let item = AVMetadataItem.metadataItems(from: items, filteredByIdentifier: .commonIdentifierTitle).first {
                audioFile.title = try await item.load(.stringValue)
            }
            
            // Artist
            if let item = AVMetadataItem.metadataItems(from: items, filteredByIdentifier: .commonIdentifierArtist).first {
                audioFile.artist = try await item.load(.stringValue)
            }
            
            // Artwork
            if let item = AVMetadataItem.metadataItems(from: items, filteredByIdentifier: .commonIdentifierArtwork).first,
               let artworkData = try await item.load(.dataValue) {
                audioFile.artwork = UIImage(data: artworkData)
            }
            
            return audioFile
        } catch {
            print("Building audio file metadata failed: \(error)")
            throw AudioFileError.invalidImport(fileName: url.lastPathComponent)
        }
    }
    
    func cacheAudioFile(_ audioFile: AudioFileItem) async throws -> URL {
        let didStartAccess = audioFile.url.startAccessingSecurityScopedResource()
        defer { if didStartAccess { audioFile.url.stopAccessingSecurityScopedResource() } }
        
        let fileName = audioFile.url.lastPathComponent
        let destPath = "\(cachedAudioFolderName)/\(fileName)"
        
        do {
            return try await fileStorage.copyItemFromURL(audioFile.url, to: destPath)
        } catch {
            throw AudioFileError.unableToCache(fileName: audioFile.url.lastPathComponent)
        }
    }
    
    func deleteAudioFile(_ audioFile: AudioFileItem) async throws {
        let fileName = audioFile.url.lastPathComponent
        let destPath = "\(cachedAudioFolderName)/\(fileName)"
        
        try await fileStorage.delete(path: destPath)
    }
}
