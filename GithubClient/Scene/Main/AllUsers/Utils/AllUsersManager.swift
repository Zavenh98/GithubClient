//
//  AllUsersManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 20.01.26.
//

import Foundation

protocol AllUsersManagerInput {
    func fetchUsers(since: Int?, perPage: Int) async throws -> [User]
    func loadCachedUsers() -> [User]
    func fetchUserRepos(username: String) async throws -> [Repository]
}

class AllUsersManager: AllUsersManagerInput {
    
    private let defaultsStorageManager: DefaultsStorageManagerInput
    private let networkManager: NetworkManagerInput
    
    init(
        defaultsStorsageManager: DefaultsStorageManagerInput,
        networkManager: NetworkManagerInput
    ) {
        self.defaultsStorageManager = defaultsStorsageManager
        self.networkManager = networkManager
    }
    
    func fetchUsers(since: Int?, perPage: Int) async throws -> [User] {
        let request = AllUsersRequest(since: since, perPage: perPage)
        
        let dtos = try await networkManager.request(request)
        let users = dtos.map(User.init(dto:))
        try? cacheUsers(users)
        return users
    }
    
    func loadCachedUsers() -> [User] {
        (try? defaultsStorageManager.getObject([User].self, for: .allUsersCache)) ?? []
    }
    
    private func cacheUsers(_ users: [User]) throws {
        try defaultsStorageManager.setObject(users, for: .allUsersCache)
    }
    
    func fetchUserRepos(username: String) async throws -> [Repository] {
        let request = UserDetailsRequest(username: username)
        return try await networkManager.request(request).map { Repository(dto: $0)}
    }
}
