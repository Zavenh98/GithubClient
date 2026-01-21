//
//  RemoteAvatarView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 19.01.26.
//

import SwiftUI

struct RemoteAvatarView: View {
    private let url: String
    private let height: CGFloat
    
    init(
        url: String,
        height: CGFloat = R.Sizes.Images.small
    ) {
        self.url = url
        self.height = height
    }
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .fitToAspectRatio()
        } placeholder: {
            Image(.avatarPlaceholder)
                .fitToAspectRatio()
        }
        .clipShape(.circle)
        .frame(height: height)
    }
}

#Preview {
    RemoteAvatarView(url: "https://hws.dev/img/logor.png")
}
