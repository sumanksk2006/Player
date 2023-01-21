//
//  ConsoleLogger.swift
//  Player
//
//  Created by Suman Kumar Konakalla on 1/20/23.
//

import Foundation
import AVFoundation

enum PlayerStatus{
    case play
    case pause
    case end
}

final class ConsoleLogger {
    let player: AVPlayer
    var statusTimer: Timer?
    var currentLog: String = ""
    typealias PlayerPosition = (duration: String?, current: String)
    init(_ player: AVPlayer) {
        self.player = player
    }
    
    func startStatusLogger() {
        if statusTimer == nil  {
            statusTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
                self.logCurrentPlayStatus()
            })
        } else {
            statusTimer?.invalidate()
        }
        statusTimer?.fire()
    }
    
    func endStatusLogger() {
        statusTimer?.invalidate()
        statusTimer = nil
    }
    
    @objc func logCurrentPlayStatus() {
        if let position = getCurrentPosition(), let total = position.duration {
            currentLog = "Player is at \(position.current) of \(total) Seconds"
            print(Constants.logIdentifier, currentLog )
        }
    }
    
    private func getCurrentPosition() -> PlayerPosition? {
        if let currentMedia = player.currentItem, !CMTimeGetSeconds(currentMedia.duration).isNaN  {
            let totalDuration = String(format: "%.1f", CMTimeGetSeconds(currentMedia.duration))
            let current =  String(format: "%.1f", CMTimeGetSeconds(currentMedia.currentTime()))
            return (totalDuration, current)
        }
        return (nil,"0.0")
    }
    
    private func logPlayerPlay() {
        if let currentPosition = getCurrentPosition() {
            let status = (currentPosition.current == "0.0" ? "Starts" : "Resumed")
            currentLog = "Player \(status) Playing from \(currentPosition.current) sec position"
            print(Constants.logIdentifier, currentLog)
        }
    }
    
    private func logPlayerPause() {
        currentLog = "Player Paused"
        print(Constants.logIdentifier, currentLog)
    }
    
    private func logPlayerEndMedia() {
        currentLog = "Player Finished Playing"
        print(Constants.logIdentifier, "Player Finished Playing")
    }
    
    func logCurrentStatus(_ status: PlayerStatus) {
        switch status {
        case .play:
            logPlayerPlay()
        case .pause:
            logPlayerPause()
        case .end:
            logPlayerEndMedia()
        }
    }
    
    
}
