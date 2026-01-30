//
//  AudioPlaybackManagerDelegate.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 30.01.26.
//

import Foundation

@MainActor
protocol AudioPlaybackManagerDelegate: AnyObject {
    func playbackDidFinish()
    func playbackDidReceivePlay()
    func playbackDidReceivePause()
    func playbackDidReceivePrevious()
    func playbackDidReceiveNext()
}
