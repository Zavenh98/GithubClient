//
//  PinchPanRemoteImage.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 21.01.26.
//

import SwiftUI

struct PinchPanRemoteImage: View {
    @State private var zoom: CGFloat = 1
    @State private var zoomAnchor: UnitPoint = .center
    @State private var dragOffset: CGSize = .zero
    
    private let urlString: String
    private let showLoading: Bool
    private let clipShape: RemoteImage.ClipShape
    
    init(
        urlString: String,
        showLoading: Bool = false,
        clipShape: RemoteImage.ClipShape = .circle
    ) {
        self.urlString = urlString
        self.showLoading = showLoading
        self.clipShape = clipShape
    }
    
    var body: some View {
        RemoteImage(urlString: urlString, showLoading: showLoading, clipShape: clipShape)
            .scaleEffect(zoom, anchor: zoomAnchor)
            .offset(dragOffset)
            .overlay {
                PinchPanGestureOverlay(
                    zoom: $zoom,
                    zoomAnchor: $zoomAnchor,
                    dragOffset: $dragOffset)
            }
    }
}

#Preview {
    PinchPanRemoteImage(
        urlString: "https://avatars.githubusercontent.com/u/2?v=4",
        showLoading: true,
        clipShape: .circle)
}
