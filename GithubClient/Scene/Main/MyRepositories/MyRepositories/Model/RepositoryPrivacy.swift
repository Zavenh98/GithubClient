//
//  RepositoryPrivacy.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 19.01.26.
//

import SwiftUI

enum RepositoryPrivacy: Int, Codable {
    case publicRepo = 0
    case privateRepo = 1
    
    var title: String {
        switch self {
        case .publicRepo:
            return "Public"
        case .privateRepo:
            return "Private"
        }
    }
    
    var color: Color {
        switch self {
        case .publicRepo:
            return .brandMainPurple.opacity(0.8)
        case .privateRepo:
            return .textSecondary
        }
    }
}
