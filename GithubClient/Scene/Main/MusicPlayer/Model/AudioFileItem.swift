//
//  AudioFileItem.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 26.01.26.
//

import UIKit

struct AudioFileItem: Identifiable, Equatable, Hashable {
    let url: URL
    var title: String?
    var artist: String?
    var artwork: UIImage?
    var fileSize: String?
    var duration: TimeInterval?
    
    var id: URL { url }
    var fileName: String { url.deletingPathExtension().lastPathComponent }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.fileName == rhs.fileName
        // Add id 
    }
}
