//
//  PlayerView.swift
//  Player
//
//  Created by Suman Kumar Konakalla on 1/20/23.
//

import UIKit

class PlayerView: UIView {
    let viewModel: ViewModel
    
    init(_ viewModel: ViewModel, frame: CGRect) {
        self.viewModel = viewModel
       
        super.init(frame: frame)
        self.frame = frame
    }
    
    func configurePlayer() {
        viewModel.configurePlayerToPlayMedia()
        self.layer.addSublayer(viewModel.getPlayerLayer(for: bounds))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
