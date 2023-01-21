//
//  PlayerViewModelTests.swift
//  PlayerTests
//
//  Created by Suman Kumar Konakalla on 1/20/23.
//

import XCTest
@testable import Player

final class PlayerViewModelTests: XCTestCase {

    var viewModel: ViewModel?
    override func setUpWithError() throws {
        viewModel = ViewModel(DataModel())
    }

    
    func testPlayerLayer() {
        XCTAssertNotNil(viewModel?.getPlayerLayer(for: CGRectZero))
    }
    
    func testLoggerWhilePlayingMedia() {
        viewModel?.configurePlayerToPlayMedia()
        var exp = expectation(for: NSPredicate(format: "SELF == %@", "Player is at 0.0 of 1800.0 Seconds"), evaluatedWith: viewModel?.logger?.currentLog)
        let _ = XCTWaiter.wait(for: [exp], timeout: 1.0)

        
        viewModel?.playOrPauseMedia() { isPlaying in
            XCTAssertFalse(isPlaying)
            XCTAssertEqual(self.viewModel?.logger?.currentLog, "Player Paused")
        }

        exp = expectation(for: NSPredicate(format: "SELF == %@", "Player Finished Playing"), evaluatedWith: viewModel?.logger?.currentLog)
        viewModel?.logger?.logCurrentStatus(.end)

        let _ = XCTWaiter.wait(for: [exp], timeout: 0.5)
    }

}
