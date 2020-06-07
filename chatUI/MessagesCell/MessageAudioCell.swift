//
//  MessageAudioCell.swift
//  chatUI
//
//  Created by Faris Albalawi on 4/17/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.
//

import UIKit
import AVFoundation


class MessageAudioCell: MessageCell {

  static var reuseIdentifier = "MessageAudioCell"
    
   private let slider : UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1000
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(sliderPlayer), for: .touchDragInside)
        return slider
    }()
    
    private let playBtn : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(play_pause), for: UIControl.Event.touchUpInside)
        button.tag = 0
        return button
    }()
    
   private var time : UILabel = {
       let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.systemFont(ofSize : 12)
        label.textColor = .blue
        return label
    }()
    
    
    private var totalTime : UILabel = {
          let label = UILabel()
          label.text = "0:00"
          label.font = UIFont.systemFont(ofSize : 12)
          label.textColor = .blue
          return label
      }()
    
    
    private var audioPlayer = AVAudioPlayer()
    private var url: URL?
    
    override func prepareForReuse() {
         super.prepareForReuse()
      
     }
    
    override func setupUIElements() {
        self.bubbleView.addSubview(playBtn)
        self.bubbleView.addSubview(slider)
        self.bubbleView.addSubview(time)
        self.bubbleView.addSubview(totalTime)
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        bubbleView.anchor(width:bounds.width - 40 )
        playBtn.anchor(top:bubbleView.topAnchor,left:bubbleView.leftAnchor,paddingTop:10,paddingLeft: 10,width: 30,height: 30)
        slider.anchor(top:bubbleView.topAnchor,left: playBtn.rightAnchor,right: bubbleView.rightAnchor,paddingTop:10,paddingLeft:10,paddingRight: 10 )
        time.anchor(top:slider.bottomAnchor,left: playBtn.rightAnchor,bottom:bubbleView.bottomAnchor,paddingTop: 5,paddingLeft: 10,paddingBottom: 10)
        totalTime.anchor(top:slider.bottomAnchor,bottom:bubbleView.bottomAnchor,right:bubbleView.rightAnchor ,paddingTop: 5,paddingBottom:10, paddingRight: 10)
        
        
    }
    
    override func bind(withMessage message: Messages) {
         let date = dateFormatTime(date: message.createdAt)
         self.messageStatusView.dateLab.text = date
         self.url = message.audio
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: self.url!)
            audioPlayer.play()
        } catch let error {
            print("\(error)")
        }
      
    
        
        tranformUI(message.isIncoming)
    }
    
    override func tranformUI(_ isOutgoingMessage: Bool) {
        super.tranformUI(isOutgoingMessage)
        if isOutgoingMessage {
            playBtn.tintColor = .black()
            slider.tintColor = .black()
            time.textColor = .black()
            totalTime.textColor = .black()
            bubbleView.backgroundColor = .systemGray6
            leftConstrain.isActive = true
            rightConstrain.isActive = false
            stackView.alignment = .leading
            messageStatusView.setupConstraints(.left)
            messageStatusView.layoutIfNeeded()
        } else {
            playBtn.tintColor = .white
            slider.tintColor = .white
            time.textColor = .white
            totalTime.textColor = .white
            bubbleView.backgroundColor = .mainBlue
            leftConstrain.isActive = false
            rightConstrain.isActive = true
            stackView.alignment = .trailing
            messageStatusView.setupConstraints(.right)
            messageStatusView.layoutIfNeeded()
        }
    }
    
    
    @objc func play_pause() {
        audioPlayer.play()
         print("ddsdd")
   
    }
    
    @objc func sliderPlayer() {
        print("ddsdd")
    }
    
}

