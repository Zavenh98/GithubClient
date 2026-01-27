//
//  Int+Extensions.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 26.01.26.
//

import Foundation

extension Int {
    func bytesFormat() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(self))
    }
}
