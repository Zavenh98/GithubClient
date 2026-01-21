//
//  NetworkRequest.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

enum NetworkRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
    case put = "PUT"
}


protocol NetworkRequest {
    associatedtype Response = [String: Any]
    
    var path: String { get }
    var method: NetworkRequestMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
    var withAuthorization: Bool { get }
    
    func decode(_ data: Data, using: JSONDecoder) throws -> Response
}
