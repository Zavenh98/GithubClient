//
//  ArtworkImage.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 26.01.26.
//

import SwiftUI

struct ArtworkImage: View {
    let image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .fitToAspectRatio()
            } else {
                Rectangle()
                    .fill(.textDisabled)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(alignment: .bottom) {
                        Image(systemName: "music.note")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.brandMainPurple)
                            .scaleEffect(0.5)
                    }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ArtworkImage(image: nil)
}
