//
//  View+Extensions.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 28.01.26.
//

import SwiftUI

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as?
                         UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}
