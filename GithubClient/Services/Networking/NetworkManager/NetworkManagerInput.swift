//
//  NetworkManagerInput.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

protocol NetworkManagerInput {
    func request<T: NetworkRequest>(_ request: T) async throws -> T.Response
}
