//
//  ViewModel.swift
//  Player
//
//  Created by Suman Kumar Konakalla on 1/20/23.
//

import Foundation
import AVFoundation

protocol Media {
    var playerMediaStatus: MediaStatus? { get }
    var mediaURL: String { get }
}

final class ViewModel : NSObject {
    private let model: DataModel
    private var player: AVPlayer? = nil
    private var playerItem: AVPlayerItem? = nil
    private var playerStatus: MediaStatus?
    init(_ model: DataModel) {
        self.model = model
        super.init()
    }
    
    func configurePlayerToPlayMedia() {
        if let mediaURL = URL(string: model.urlString) {
            playerItem = AVPlayerItem(url: mediaURL)
            player = AVPlayer(playerItem: playerItem)
            addObservers()
        }
    }

    func getPlayerLayer(for bounds: CGRect) -> CALayer {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspect
        return playerLayer
    }
    
    func addObservers() {
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus),options: [.old, .new], context: nil)
    }

    func clearObservers() {
        player?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
}

// MARK: AVPlayer controls
extension ViewModel {
    func playMedia() {
        if playerStatus == nil {
            playerStatus = MediaStatus(self)
        }
        player?.play()
    }
    
    private func pauseMedia() {
        player?.pause()
    }
    
    func playOrPauseMedia(_ isPlaying: @escaping(Bool) -> () ) {
        if player?.timeControlStatus == .playing {
            pauseMedia()
            isPlaying(false)
        } else {
            playMedia()
            isPlaying(true)
        }
    }
    
    func playerEndsMedia() {
        playerStatus?.status = .end
    }
}

// MARK: Observer
extension ViewModel {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            var status: AVPlayerItem.Status = .unknown
            if let newStatus = change?[.newKey] as? Int {
                status = AVPlayerItem.Status(rawValue: newStatus)!
            }
            
            switch status {
            case .readyToPlay:
                playMedia()
            default:
                break
            }
        } else if keyPath == #keyPath(AVPlayer.timeControlStatus) {
            var status: AVPlayer.TimeControlStatus = .playing
            if let newStatus = change?[.newKey] as? Int {
                status = AVPlayer.TimeControlStatus(rawValue: newStatus)!
            }
            
            switch status {
            case .paused:
                playerStatus?.status = .pause
            case .playing:
                playerStatus?.status = .play
            default:
                break
            }
        }
    }
}

extension ViewModel: Media {
    var playerMediaStatus: MediaStatus? {
        self.playerStatus
    }
    
    var mediaURL: String {
        model.urlString
    }
}

extension ViewModel: MediaStatusDelegate {
    func getCurrentMediaStatus() -> PlayerPosition {
        if let media = player?.currentItem, !CMTimeGetSeconds(media.duration).isNaN  {
            let totalDuration = String(format: "%.1f", CMTimeGetSeconds(media.duration))
            let current =  String(format: "%.1f", CMTimeGetSeconds(media.currentTime()))
            return (totalDuration, current)
        }
        return (nil,"0.0")
    }
}
