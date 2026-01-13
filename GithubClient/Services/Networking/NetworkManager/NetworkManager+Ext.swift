//
//  NetworkManager+Ext.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

extension NetworkManager {
    func validate<T>(_ request: T, _ data: Data, _ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if response.statusCode == 401 {
            // TODO: - ???
            return
        } else {
            guard 200..<300 ~= response.statusCode else {
                guard
                    let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let status = dict["status"] as? String,
                    let message = dict["message"] as? String
                else { throw NetworkError.emptyError }
                
                throw NetworkError(status: status, errorCode: response.statusCode, message: message)
            }
        }
    }
}
