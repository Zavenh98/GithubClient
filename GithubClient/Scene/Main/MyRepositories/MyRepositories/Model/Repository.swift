//
//  Repository.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 18.01.26.
//

import Foundation

struct Repository: Identifiable, Equatable, Codable, Hashable {
    let id: Int
    let name: String
    let privacyType: RepositoryPrivacy
    let language: String?
    let updatedAt: Date
    let owner: RepositoryOwner
    var index: Int
    
    init(id: Int, name: String, privacyType: RepositoryPrivacy, language: String?, updatedAt: Date, owner: RepositoryOwner, index: Int) {
        self.id = id
        self.name = name
        self.privacyType = privacyType
        self.language = language
        self.updatedAt = updatedAt
        self.owner = owner
        self.index = index
    }

    init(dto: RepositoryDTO) {
        self.id = dto.id
        self.name = dto.name
        self.privacyType = RepositoryPrivacy(rawValue: dto.private.intValue) ?? .privateRepo
        self.language = dto.language
        self.updatedAt = dto.updatedAt
        self.owner = dto.owner
        self.index = 0
    }
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
