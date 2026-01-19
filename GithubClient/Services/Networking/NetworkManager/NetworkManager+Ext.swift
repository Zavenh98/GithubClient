//
//  NetworkManager+Ext.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Combine
import Foundation

extension NetworkManager {
    func validate<T>(_ request: T, _ data: Data, _ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.emptyError
        }
        
        if response.statusCode == 401 {
            throw NetworkError.unauthorized
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

// MARK: - For Combine
extension NetworkManager {
    func requestPublisher<T: NetworkRequest>(_ request: T) -> AnyPublisher<T.Response, Error>  {
        Deferred { [weak self] in
            Future { promise in
                guard let self else {
                    promise(.failure(NetworkError(status: "", errorCode: 400, message: "Publisher self error")))
                    return
                }
                Task {
                    do {
                        let value = try await self.request(request)
                        promise(.success(value))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
