//
//  NetworkManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

final class NetworkManager: NetworkManagerInput {
    let keychainManager: KeychainManagerInput
    let reachablityManager: ReachabilityManagerInput
    
    init(keychainManager: KeychainManagerInput, reachablityManager: ReachabilityManagerInput) {
        self.keychainManager = keychainManager
        self.reachablityManager = reachablityManager
    }
    
    // MARK: - Private
    private lazy var defaultSession: URLSession = {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.timeoutIntervalForRequest = 30
        return URLSession(configuration: configuration)
    }()
    
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // MARK: - NetworkManagerInput
    func request<T>(_ request: T) async throws -> T.Response where T : NetworkRequest {
        guard reachablityManager.isReachable else {
            throw NetworkError.notReachable
        }
        
        let credentials = try? keychainManager.getCredentials()
        let urlRequest = try request.buildURLRequest(credentials: credentials)
        
        let (data, urlResponse) = try await defaultSession.data(for: urlRequest)
        
        try validate(request, data, urlResponse)
        
        let decodedData = try request.decode(data, using: jsonDecoder)
        
        return decodedData
    }
}
