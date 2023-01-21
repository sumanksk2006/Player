//
//  ViewController.swift
//  Player
//
//  Created by Suman Kumar Konakalla on 1/20/23.
//

import UIKit

class ViewController: UIViewController  {
    
    
    let viewModel = ViewModel(DataModel(urlString: Constants.mediaLink))
    
    lazy var playButton: UIButton = {
        let button:UIButton = UIButton(type: .custom)
        button.backgroundColor = UIColor.lightGray
        button.setTitle(Constants.pauseMediaTitle, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(self.playButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let playerView = PlayerView(viewModel, frame: view.frame)
        self.view.addSubview(playerView)
        playerView.configurePlayer()
        
        self.view.addSubview(playButton)
        configureConstraintsForButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(mediaFinished), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.clearObservers()
    }

    func configureConstraintsForButton() {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60.0),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60.0),
            playButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60.0)
        ])
    }
    
    @objc func playButtonTapped(_ sender:UIButton)
    {
        viewModel.playOrPauseMedia() { isPlaying in
            sender.setTitle(isPlaying ? Constants.pauseMediaTitle : Constants.playMediaTitle, for: .normal)
        }
    }
    
    @objc func mediaFinished() {
        viewModel.playerEndsMedia()
    }
}
