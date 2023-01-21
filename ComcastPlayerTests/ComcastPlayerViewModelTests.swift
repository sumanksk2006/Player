//
//  ComcastPlayerViewModelTests.swift
//  ComcastPlayerTests
//
//  Created by Suman Kumar Konakalla on 1/20/23.
//

import XCTest
@testable import ComcastPlayer

final class ComcastPlayerViewModelTests: XCTestCase {

    var viewModel: ViewModel?
    override func setUpWithError() throws {
        viewModel = ViewModel(DataModel())
    }

    
    func testPlayerLayer() {
        XCTAssertNotNil(viewModel?.getPlayerLayer(for: CGRectZero))
    }
    
    func testLoggerWhilePlayingMedia() {
        viewModel?.configurePlayerToPlayMedia()
        var exp = expectation(description: "Test after 1 seconds")
        let _ = XCTWaiter.wait(for: [exp], timeout: 0.6)

        XCTAssertEqual(viewModel?.logger?.currentLog, "Player is at 0.0 of 1800.0 Seconds")
        
        exp = expectation(description: "Test after 2 seconds")
        let _ = XCTWaiter.wait(for: [exp], timeout: 2.0)
        
        viewModel?.playOrPauseMedia() { isPlaying in
            XCTAssertFalse(isPlaying)
            XCTAssertEqual(self.viewModel?.logger?.currentLog, "Player Paused")
        }

        exp = expectation(description: "Test after 1 seconds")
        let _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        
        viewModel?.logger?.logCurrentStatus(.end)
        XCTAssertEqual(self.viewModel?.logger?.currentLog, "Player Finished Playing")
    }

}
