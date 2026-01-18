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
