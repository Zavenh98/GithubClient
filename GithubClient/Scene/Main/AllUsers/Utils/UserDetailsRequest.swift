//
//  UserDetailsRequest.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 21.01.26.
//

import Foundation

struct UserDetailsRequest: NetworkRequest {
    typealias Response = [RepositoryDTO]

    let path: String
    let method: NetworkRequestMethod = .get
    let withAuthorization: Bool = true

    init(username: String) {
        self.path = "/users/\(username)/repos"
    }
}
