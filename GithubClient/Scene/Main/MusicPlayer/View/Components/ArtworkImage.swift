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
                Image(.artworkPlaceholder)
                    .fitToAspectRatio()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: R.Corners.small))
    }
}

#Preview {
    ArtworkImage(image: nil)
}
