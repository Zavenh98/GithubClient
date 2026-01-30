//
//  AudioPlaybackManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 27.01.26.
//

import Foundation
import AVFoundation
import MediaPlayer

final class AudioPlaybackManager: NSObject, AudioPlaybackManagerInput {
    private var player: AVPlayer?
    weak var delegate: AudioPlaybackManagerDelegate?
    
    override init() {
        super.init()
        
        configureAudioSession()
        setupNotifications()
        setupRemoteComands()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.endReceivingRemoteControlEvents()
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
    
    func seek(to time: TimeInterval) {
        guard let player else { return }
        let cmTime = CMTime(seconds: max(0, time), preferredTimescale: 600)
        player.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func updateNowPlaying(item: AudioFileItem, isPlaying: Bool, elapsed: TimeInterval) {
        var info: [String: Any] = [:]
        
        // Title
        info[MPMediaItemPropertyTitle] = item.title ?? item.fileName
        
        // Artist
        if let artist = item.artist {
            info[MPMediaItemPropertyArtist] = artist
        }
        
        // Duration
        if let duration = item.duration {
            info[MPMediaItemPropertyPlaybackDuration] = duration
        }
        
        // Current time
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = max(0, elapsed)
        
        // Playback rate
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        // Artwork
        let image = item.artwork ?? UIImage(named: "artwork_placeholder")!
        let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
        info[MPMediaItemPropertyArtwork] = artwork
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
}

// MARK: - Remote Comands
extension AudioPlaybackManager {
    private func setupRemoteComands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            if self.player?.rate == 0.0 {
                self.delegate?.playbackDidReceivePlay()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            if self.player?.rate == 1.0 {
                self.delegate?.playbackDidReceivePause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            self.delegate?.playbackDidReceivePrevious()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            self.delegate?.playbackDidReceiveNext()
            return .success
        }
    }
    
    @objc private func didFinishCurrentAudio() {
        delegate?.playbackDidFinish()
    }
}

// MARK: - Interuptions
extension AudioPlaybackManager {
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruptions(_:)),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance()
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange(_:)),
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance()
        )
    }
    
    @objc private func handleInterruptions(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
        
        switch type {
            
        case .began:
            self.delegate?.playbackDidReceivePause()
            
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            
            if options.contains(.shouldResume) {
                self.delegate?.playbackDidReceivePlay()
            }
            
        @unknown default:
            break
        }
    }
    
    @objc private func handleRouteChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        switch reason {
            
        case .oldDeviceUnavailable:
            // When headphones or BT device disconnected
            self.delegate?.playbackDidReceivePause()
        default:
            break
        }
    }
}
