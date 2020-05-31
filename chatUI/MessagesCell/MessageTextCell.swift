//
//  MessageTextCell.swift
//  chatUI
//
//  Created by Faris Albalawi on 4/17/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.
//

import UIKit


class MessageTextCell: MessageCell {
    
   static var reuseIdentifier = "MessageTextCell"
    
   private lazy var messageLabel: ContextLabel = {
        let messageLabel = ContextLabel(frame: .zero, didTouch: { (touchResult) in
            self.contextLabel(didTouchWithTouchResult: touchResult)
        })

        // Custoim Underline Style
        messageLabel.underlineStyle = { (linkResult) in
            switch linkResult.detectionType {
            case .url, .email, .phoneNumber:
                return .single
            default:
                return []
            }
        }

        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.textAlignment = .natural
        messageLabel.numberOfLines = 0
        messageLabel.lineSpacing = 2
        messageLabel.sizeToFit()
        return messageLabel
    }()

    
    override func prepareForReuse() {
         super.prepareForReuse()
        messageLabel.text = nil
        messageLabel.underlineStyle = { (linkResult) in
            switch linkResult.detectionType {
                case .url, .email, .phoneNumber:
                 return .single
                default:
                 return []
             }
         }
         messageLabel.text = nil
        
     }
    
    override func setupUIElements() {
        bubbleView.addSubview(messageLabel)
        messageLabel.preferredMaxLayoutWidth = bounds.width - 40
        setupConstraints()
    }
    
    private func setupConstraints() {
        messageLabel.anchor(top: bubbleView.topAnchor,left: bubbleView.leftAnchor
               ,bottom: bubbleView.bottomAnchor,right: bubbleView.rightAnchor,
                paddingTop: 15,paddingLeft: 15,paddingBottom: 15,paddingRight: 15)
    }
    
    
    
    override func bind(withMessage message: Messages) {
        messageLabel.text = message.text
        let date = dateFormatTime(date: message.createdAt)
        messageStatusView.dateLab.text = date
        tranformUI(message.isIncoming)
    }
    
    // add constraints to subviews and set color
    override func tranformUI(_ isOutgoingMessage: Bool) {
        super.tranformUI(isOutgoingMessage)
          if isOutgoingMessage {
              
              messageLabel.textColor = .black()
              messageLabel.foregroundHighlightedColor = { (linkResult) in return .black() }
              messageLabel.foregroundColor = { (linkResult) in return .black() }
        
            
              bubbleView.backgroundColor = .systemGray6
              leftConstrain.isActive = true
              rightConstrain.isActive = false
              stackView.alignment = .leading
              messageStatusView.setupConstraints(.left)
              messageStatusView.layoutIfNeeded()
            
          } else {
        
              messageLabel.textColor = .white
              messageLabel.foregroundHighlightedColor = { (linkResult) in return .white }
              messageLabel.foregroundColor = { (linkResult) in return .white }
              bubbleView.backgroundColor = .mainBlue
              leftConstrain.isActive = false
              rightConstrain.isActive = true
              stackView.alignment = .trailing
              messageStatusView.setupConstraints(.right)
              messageStatusView.layoutIfNeeded()
          }

      }
    
    

    
   private func contextLabel(didTouchWithTouchResult touchResult: TouchResult) {
        guard let textLink = touchResult.linkResult else { return }
        switch touchResult.state {
        case .ended:
            switch textLink.detectionType {
            case .url:
                print("url \(textLink.text)")
            case .email:
                print("email \(textLink.text)")
            case .phoneNumber:
                print("phoneNumber \(textLink.text)")
            default:
                print("default")
            }
            
        default:
            break
        }
    }
    

}
