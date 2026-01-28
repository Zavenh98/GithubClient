//
//  FileStorageManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 18.01.26.
//

import Foundation

enum FileStorageError: Error {
    case fileNotFound
}

actor FileStorageManager {

    private let fileManager: FileManager = .default

    private var documentsURL: URL {
        URL.documentsDirectory
    }

    private func url(for path: String) -> URL {
        documentsURL.appending(path: path)
    }

    func saveData(_ data: Data, at path: String) throws {
        let fileURL = url(for: path)
        
        let directoryURL = fileURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        
        try data.write(to: fileURL, options: [.atomic])
    }

    func loadData(from path: String) throws -> Data {
        let fileURL = url(for: path)
        guard fileManager.fileExists(atPath: fileURL.path) else { throw FileStorageError.fileNotFound }
        return try Data(contentsOf: fileURL)
    }

    func delete(path: String) throws {
        let fileURL = url(for: path)
        guard fileManager.fileExists(atPath: fileURL.path) else { return }
        try fileManager.removeItem(at: fileURL)
    }
}


extension FileStorageManager {
    func copyItemFromURL(_ fileURL: URL, to path: String) throws -> URL {
        let destinationURL = url(for: path)
        
        let directoryURL = destinationURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        
        if fileManager.fileExists(atPath: destinationURL.path) {
            return destinationURL
        }
        
        try fileManager.copyItem(at: fileURL, to: destinationURL)
        return destinationURL
    }

    func loadURLs(in folderPath: String) throws -> [URL] {
        let folderURL = url(for: folderPath)

        guard fileManager.fileExists(atPath: folderURL.path) else {
            return []
        }

        return try fileManager.contentsOfDirectory(
            at: folderURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
    }
}
