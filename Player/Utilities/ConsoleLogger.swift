//
//  ConsoleLogger.swift
//  Player
//
//  Created by Suman Kumar Konakalla on 1/20/23.
//

import Foundation

enum PlayerStatus{
    case play
    case pause
    case end
    case unknown
}
typealias PlayerPosition = (duration: String?, current: String)

final class ConsoleLogger {
    let mediaStatus: MediaStatusDelegate
    var statusTimer: Timer?
    var currentLog: String = ""
    init(_ mediaStatus: MediaStatusDelegate) {
        self.mediaStatus = mediaStatus
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
        let currentPosition = mediaStatus.getCurrentMediaStatus()
        if let total = currentPosition.duration {
            currentLog = String(format: Constants.timerLogText, currentPosition.current, total)
            print(Constants.logIdentifier, currentLog )
        }
    }
    
    
    private func logPlayerPlay() {
        let currentPosition = mediaStatus.getCurrentMediaStatus()
        let status = (currentPosition.current == "0.0" ? Constants.playerStartStatus : Constants.playerResumeStatus)
        currentLog = String(format: Constants.playLogText, status, currentPosition.current)
        print(Constants.logIdentifier, currentLog)
    }
    
    private func logPlayerPause() {
        currentLog = Constants.pauseLogText
        print(Constants.logIdentifier, currentLog)
    }
    
    private func logPlayerEndMedia() {
        currentLog = Constants.finishLogText
        print(Constants.logIdentifier, currentLog)
    }
    
    func logCurrentStatus(_ status: PlayerStatus) {
        switch status {
        case .play:
            logPlayerPlay()
            startStatusLogger()
        case .pause:
            logPlayerPause()
            endStatusLogger()
        case .end:
            logPlayerEndMedia()
            endStatusLogger()
        default:
            break
        }
    }
    
    
}
