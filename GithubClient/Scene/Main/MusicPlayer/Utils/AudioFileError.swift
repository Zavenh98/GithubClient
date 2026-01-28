//
//  AudioFileError.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 27.01.26.
//

import Foundation

enum AudioFileError: LocalizedError {
    case invalidImport(fileName: String)
    case unableToCache(fileName: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidImport(let fileName):
            return "You imported invalid audio file: \(fileName)"
        case .unableToCache(let fileName):
            return "Unable to cache audio file: \(fileName)"
        }
    }
}
