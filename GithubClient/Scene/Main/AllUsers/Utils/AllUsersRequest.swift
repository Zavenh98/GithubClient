//
//  AllUsersRequest.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 20.01.26.
//

import Foundation

struct AllUsersRequest: NetworkRequest {
    typealias Response = [UserDTO]

    let path: String = "/users"
    let method: NetworkRequestMethod = .get
    let withAuthorization: Bool = true

    let since: Int?
    let perPage: Int

    init(since: Int?, perPage: Int = 30) {
        self.since = since
        self.perPage = perPage
    }

    var queryItems: [URLQueryItem]? {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        if let since {
            items.append(URLQueryItem(name: "since", value: "\(since)"))
        }
        return items
    }
}

struct UserDTO: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }
}
