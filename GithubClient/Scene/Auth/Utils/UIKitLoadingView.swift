//
//  UIKitLoadingView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 14.01.26.
//

import UIKit

class UIKitLoadingView: UIView {
    private let backgroundBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let indicatorBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private let indicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    private func configureView() {
        isHidden = true
        
        backgroundBlurView.frame = bounds
        backgroundBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundBlurView.alpha = 0.5
        addSubview(backgroundBlurView)
        
        indicatorBackgroundView.backgroundColor = .textDisabled
        indicatorBackgroundView.layer.cornerRadius = 20
        indicatorBackgroundView.layer.masksToBounds = true
        indicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorBackgroundView)

        indicator.color = .brandMainPurple
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)

        NSLayoutConstraint.activate([
            indicatorBackgroundView.widthAnchor.constraint(equalToConstant: 100),
            indicatorBackgroundView.heightAnchor.constraint(equalToConstant: 100),
            indicatorBackgroundView.centerXAnchor.constraint(equalTo: backgroundBlurView.centerXAnchor),
            indicatorBackgroundView.centerYAnchor.constraint(equalTo: backgroundBlurView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: indicatorBackgroundView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: indicatorBackgroundView.centerYAnchor)
        ])
    }

    func startAnimate() {
        isHidden = false
        indicator.startAnimating()
    }

    func stopAnimate() {
        indicator.stopAnimating()
        isHidden = true
    }
}
