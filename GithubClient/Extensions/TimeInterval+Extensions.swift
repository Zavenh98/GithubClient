//
//  TimeInterval+Extensions.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 26.01.26.
//

import Foundation

extension TimeInterval {
    func toMinuteSecond() -> String {
        guard self.isFinite, self >= 0 else { return "--:--" }
        let total = Int(self.rounded())
        let m = total / 60
        let s = total % 60
        return String(format: "%d:%02d", m, s)
    }
}
