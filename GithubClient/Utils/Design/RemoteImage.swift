//
//  RemoteImage.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 19.01.26.
//

import SwiftUI

struct RemoteImage: View {
    enum ClipShape { case circle, square }
    
    private let urlString: String
    private let showLoading: Bool
    private let clipShape: ClipShape
    
    init(
        urlString: String,
        showLoading: Bool = false,
        clipShape: ClipShape = .circle
    ) {
        self.urlString = urlString
        self.showLoading = showLoading
        self.clipShape = clipShape
    }
    
    var body: some View {
        AsyncImage(url: URL(string: urlString),
                   transaction: Transaction(animation: .easeInOut)) { phase in
            Group {
                switch phase {
                case .empty:
                    if showLoading {
                        ZStack {
                            Color(.systemGray5)
                            ProgressView()
                        }
                        .aspectRatio(1, contentMode: .fit)
                    } else {
                        Image(.avatarPlaceholder)
                            .fitToAspectRatio()
                    }
                case .failure:
                    Image(.avatarPlaceholder)
                        .fitToAspectRatio()
                case .success(let image):
                    image
                        .fitToAspectRatio()
                @unknown default:
                    Image(.avatarPlaceholder)
                        .fitToAspectRatio()
                }
            }
            .clipShape(clipShape == .circle ? AnyShape(Circle()) : AnyShape(Rectangle()))
        }
    }
}

#Preview {
    RemoteImage(
        urlString: "https://avatars.githubusercontent.com/u/2?v=4",
        showLoading: true,
        clipShape: .circle)
}
