//
//  User.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 20.01.26.
//

import Foundation

struct User: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let login: String
    let avatarUrl: String?
    var index: Int
    
    init(id: Int, login: String, avatarUrl: String?) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.index = 0
    }

    init(dto: UserDTO) {
        self.id = dto.id
        self.login = dto.login
        self.avatarUrl = dto.avatarUrl
        self.index = 0
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
