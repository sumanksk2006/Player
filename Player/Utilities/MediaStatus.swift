//
//  MediaStatus.swift
//  Player
//
//  Created by Suman Kumar Konakalla on 1/22/23.
//

protocol MediaStatusDelegate {
    func getCurrentMediaStatus() -> PlayerPosition
}


final class MediaStatus {
    
    private var logger: ConsoleLogger?
    let delegate: MediaStatusDelegate
    
    var status: PlayerStatus = .unknown {
        didSet {
            logger?.logCurrentStatus(status)
        }
    }
    
    init(_ mediaDelegate: MediaStatusDelegate) {
        self.delegate = mediaDelegate
        logger = ConsoleLogger(self)
    }
    
}

extension MediaStatus: MediaStatusDelegate {
    func getCurrentMediaStatus() -> PlayerPosition {
        delegate.getCurrentMediaStatus()
    }
}

extension MediaStatus {
    var currentLog: String {
        logger?.currentLog ?? ""
    }
}
