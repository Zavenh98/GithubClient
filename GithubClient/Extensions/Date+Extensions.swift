//
//  Date+Extensions.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 19.01.26.
//

import Foundation

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
