//
//  Image+Extensions.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 18.01.26.
//

import SwiftUI

struct FitToAspectRatio: ViewModifier {
    
    private let aspectRatio: CGFloat
    
    init(_ aspectRatio: CGFloat) {
        self.aspectRatio = aspectRatio
    }
    
    
    public func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.clear))
                .aspectRatio(aspectRatio, contentMode: .fit)

            content
                .scaledToFill()
                .layoutPriority(-1)
        }
        .clipped()
    }
}

extension Image {
    func fitToAspectRatio(_ aspectRatio: CGFloat = 1) -> some View {
        self.resizable().modifier(FitToAspectRatio(aspectRatio))
    }
}
