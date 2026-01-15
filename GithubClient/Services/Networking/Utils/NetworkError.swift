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
    
    static let notReachable: Self = .init(
        status: "notReachable", errorCode: 404, message: "There is no internet connection.")
    static let unauthorized: Self = .init(
        status: "unauthorized", errorCode: 401, message: "Unauthorized")
    static let emptyError: Self = .init(
        status: "emptyError", errorCode: 404, message: "Something went wrong, please try again later.")
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.status == rhs.status
    }
}
