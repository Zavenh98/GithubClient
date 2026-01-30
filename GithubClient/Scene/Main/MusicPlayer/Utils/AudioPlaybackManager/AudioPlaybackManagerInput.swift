//
//  AudioPlaybackManagerInput.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 30.01.26.
//

import Foundation

protocol AudioPlaybackManagerInput: AnyObject {
    var delegate: AudioPlaybackManagerDelegate? { get set }
    var currentTime: TimeInterval { get }
    
    func setAudio(url: URL)
    func play()
    func pause()
    func seek(to time: TimeInterval)
    func updateNowPlaying(item: AudioFileItem, isPlaying: Bool, elapsed: TimeInterval)
}
