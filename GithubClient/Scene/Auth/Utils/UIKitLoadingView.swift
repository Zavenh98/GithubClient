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
        
        // Background
        addSubview(backgroundBlurView)
        backgroundBlurView.alpha = 0.5
        backgroundBlurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundBlurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBlurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBlurView.topAnchor.constraint(equalTo: topAnchor),
            backgroundBlurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Indicator Background
        addSubview(indicatorBackgroundView)
        indicatorBackgroundView.backgroundColor = .textDisabled
        indicatorBackgroundView.layer.cornerRadius = 20
        indicatorBackgroundView.layer.masksToBounds = true
        indicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorBackgroundView.widthAnchor.constraint(equalToConstant: 100),
            indicatorBackgroundView.heightAnchor.constraint(equalToConstant: 100),
            indicatorBackgroundView.centerXAnchor.constraint(equalTo: backgroundBlurView.centerXAnchor),
            indicatorBackgroundView.centerYAnchor.constraint(equalTo: backgroundBlurView.centerYAnchor),
        ])

        // Indicator 
        addSubview(indicator)
        indicator.color = .brandMainPurple
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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
