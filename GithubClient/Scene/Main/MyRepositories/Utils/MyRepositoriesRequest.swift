//
//  MyRepositoriesRequest.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 18.01.26.
//

import Foundation

struct MyRepositoriesRequest: NetworkRequest {
    typealias Response = [RepositoryDTO]
    
    let path: String = "/user/repos"
    let method: NetworkRequestMethod = .get
    let withAuthorization: Bool = true
    
    let page: Int
    let perPage: Int

    init(page: Int, perPage: Int) {
        self.page = page
        self.perPage = perPage
    }
    
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
    }
}

struct RepositoryDTO: Decodable {
    let id: Int
    let name: String
    let `private` : Bool
    let language: String?
    let owner: RepositoryOwner
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, name, `private`, language, owner, updatedAt = "updated_at"
    }
}

struct RepositoryOwner: Codable {
    let login: String
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
