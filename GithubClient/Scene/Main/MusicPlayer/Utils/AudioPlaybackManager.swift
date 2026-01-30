//
//  AudioPlaybackManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 27.01.26.
//

import Foundation
import AVFoundation

protocol AudioPlaybackManagerInput: AnyObject {
    var onFinished: (() -> Void)? { get set }
    var currentTime: TimeInterval { get }
    
    func setAudio(url: URL)
    func play()
    func pause()
    func stop()
    func seek(to time: TimeInterval)
}

final class AudioPlaybackManager: NSObject, AudioPlaybackManagerInput {
    private var player: AVPlayer?
    var onFinished: (() -> Void)?
//    private var session = AVAudioSession.sharedInstance()

    override init() {
        super.init()
        
        configureAudioSession()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var currentTime: TimeInterval {
        player?.currentTime().seconds ?? 0
    }
    
    func setAudio(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        
        // Remove current notification for did finish audio
        NotificationCenter.default.removeObserver(
            self,
            name: AVPlayerItem.didPlayToEndTimeNotification,
            object: player?.currentItem
        )

        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        // Add notification for did finish audio
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFinishCurrentAudio),
            name: AVPlayerItem.didPlayToEndTimeNotification,
            object: playerItem
        )
    }

    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }

    func stop() {
        player?.pause()
        player = nil
    }
    
    func seek(to time: TimeInterval) {
        guard let player else { return }
        let cmTime = CMTime(seconds: max(0, time), preferredTimescale: 600)
        player.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    // MARK: - Private methods
    
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true, options: [.notifyOthersOnDeactivation])
//            try session.overrideOutputAudioPort(.speaker)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
    
    @objc private func didFinishCurrentAudio() {
        onFinished?()
    }
}
