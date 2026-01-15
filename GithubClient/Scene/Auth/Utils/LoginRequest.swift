//
//  LoginRequest.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

struct LoginRequest: NetworkRequest {
    typealias Response = Void
    
    let path: String = "/user"
    let method: NetworkRequestMethod = .get
    let headers: [String : String]?
    
    init(credentials: Credentials) {
        let authString = "\(credentials.login):\(credentials.token)"
        let base64Auth = Data(authString.utf8).base64EncodedString()
        self.headers = ["Authorization" : "Basic \(base64Auth)"]
    }
}
