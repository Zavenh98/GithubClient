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
                    .fill(.gray)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(alignment: .bottom) {
                        Image(systemName: "music.note")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.brandMainPurple)
                            .scaleEffect(0.4)
                    }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: R.Corners.small))
    }
}

#Preview {
    ArtworkImage(image: nil)
}
