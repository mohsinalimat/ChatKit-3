//
//  MessegesStyle.swift
//  chatUI
//
//  Created by Faris Albalawi on 6/13/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.
//

import UIKit

public protocol MessegesStyle {
    
    /// The background color of the chat view
    var backgroundColor: UIColor { get }
    
    /// The placeholder that is displayed in the input view
    var inputPlaceholder: String { get }
    
    /// The color of text used by the placeholder in input view
    var inputPlaceholderTextColor: UIColor { get }
    
    // The color of the textview in the input view
    var inputTextViewBackgroundColor : UIColor { get }
    
    /// The text color of outgoing messages
    var outgoingTextColor: UIColor { get }
    
     /// The text Bubble of outgoing messages
    var outgoingBubbleColor: UIColor { get }
    
    /// The text color of incoming messages
    var incomingTextColor: UIColor { get }
    
    /// The text Bubble of incoming messages
    var incomingBubbleColor: UIColor { get }

    
    
}


public struct chatKitStyle: MessegesStyle {
    public var backgroundColor: UIColor = .setColor(.systemBackground, Light: .systemBackground)
    
    public var inputPlaceholder: String = "Message"
    
    public var inputPlaceholderTextColor: UIColor
    
    public var inputTextViewBackgroundColor: UIColor
    
    public var outgoingTextColor: UIColor
    
    public var outgoingBubbleColor: UIColor
    
    public var incomingTextColor: UIColor
    
    public var incomingBubbleColor: UIColor
    
    
}
