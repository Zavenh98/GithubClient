//
//  ActivityIndicatorView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 20.01.26.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    var isAnimating: Bool
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .brandMainPurple
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
