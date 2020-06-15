//
//  MessageCell.swift
//  chatUI
//
//  Created by Faris Albalawi on 4/17/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.
//

import UIKit

enum PositionInBlock {
    case top
    case center
    case bottom
    case single
}



class MessageCell: UITableViewCell {
    
     open var styles = ChatKit.Styles
    
     var bubbleView: UIView = {
        let bubble = UIView()
        bubble.layer.cornerRadius = 20
        bubble.clipsToBounds = true
        return bubble
    }()
    
    
     var stackView: UIStackView = {
         let stackView = UIStackView()
         stackView.backgroundColor = .clear
         stackView.axis = .vertical
         stackView.distribution = .fill
         stackView.alignment = .leading
         stackView.layoutMargins = UIEdgeInsets(top: 2, left: 15, bottom: 2, right: 15)
         stackView.isLayoutMarginsRelativeArrangement = true
         return stackView
     }()
    
     var messageStatusView: MessageStatusView = {
        let view = MessageStatusView()
        view.backgroundColor = .clear
        return view
    }()


    
     var leftConstrain: NSLayoutConstraint!
     var rightConstrain: NSLayoutConstraint!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(stackView)
        stackView.addArrangedSubview(bubbleView)
        stackView.addArrangedSubview(messageStatusView)
        
        stackView.anchor(top: topAnchor,bottom: bottomAnchor)
        leftConstrain = stackView.leftAnchor.constraint(equalTo: leftAnchor)
        rightConstrain = stackView.rightAnchor.constraint(equalTo: rightAnchor)

        setupUIElements()
    }
    
    
   func setupUIElements() {}
    
    
    func bind(withMessage message: Messages) {
        tranformUI(message.isIncoming)
    }
    
    
    func tranformUI(_ isIncoming: Bool) {}
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     /// Update cell position In Block (IsIncoming)
    func updateLayoutForBubbleStyleIsIncoming(_ positionInBlock: PositionInBlock) {
         switch positionInBlock {
         case .top:
             messageStatusView.isHidden = true
             bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
         case .center:
             messageStatusView.isHidden = true
             bubbleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
         case .bottom:
             messageStatusView.isHidden = false
             bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
         default:
             messageStatusView.isHidden = false
             bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
            
         }
     }
    
    /// Update cell position In Block (outgoing)
    func updateLayoutForBubbleStyle(_ positionInBlock: PositionInBlock) {
        switch positionInBlock {
           case .top:
               messageStatusView.isHidden = true
               bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
           case .center:
               messageStatusView.isHidden = true
               bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
           case .bottom:
               messageStatusView.isHidden = false
               bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
           default:
               messageStatusView.isHidden = false
               bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
           }
       }
    
}
