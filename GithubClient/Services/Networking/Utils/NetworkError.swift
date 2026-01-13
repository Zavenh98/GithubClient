//
//  NetworkError.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

struct NetworkError: LocalizedError {
    let status: String
    let errorCode: Int
    let message: String
    
    var errorDescription: String? {
        message
    }
    
    static let notReachable: Self = .init(status: "", errorCode: 404, message: "There is no internet connection.")
    static let invalidResponse: Self = .init(status: "", errorCode: 404, message: "The response is invalid.")
    static let emptyError: Self = .init(status: "", errorCode: 404, message: "Something went wrong.")
}
