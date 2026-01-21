//
//  NetworkManagerInput.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Combine
import Foundation

protocol NetworkManagerInput {
    func request<T: NetworkRequest>(_ request: T) async throws -> T.Response
    func requestPublisher<T: NetworkRequest>(_ request: T) -> AnyPublisher<T.Response, Error>
}
