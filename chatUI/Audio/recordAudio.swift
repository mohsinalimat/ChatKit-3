//
//  recordAudio.swift
//  chatUI
//
//  Created by Faris Albalawi on 6/1/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.
//

import Foundation
import UIKit

class recordAudio: UIView {
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.text = "0.0"
        lab.textColor = .systemGray2
        lab.font = UIFont.systemFont(ofSize: 30, weight: .black)
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
    }
    
    func setupUIElements() {
        self.addSubview(mainView)
        self.mainView.addSubview(timeLab)
        self.mainView.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        self.timeLab.center(inView: mainView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
