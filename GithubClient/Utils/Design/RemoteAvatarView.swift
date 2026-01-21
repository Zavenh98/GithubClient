//
//  RemoteAvatarView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 19.01.26.
//

import SwiftUI

struct RemoteAvatarView: View {
    private let url: String
    
    init(
        url: String,
    ) {
        self.url = url
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
    }
}

#Preview {
    RemoteAvatarView(url: "https://avatars.githubusercontent.com/u/2?v=4")
}
