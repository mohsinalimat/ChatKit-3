//
//  MessagesUI.swift
//  chatUI
//
//  Created Faris Albalawi on 4/17/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.


import UIKit

class MessagesUI : UIView {
 
    var cellIdentifier = "MessagesCellId"
    
    var messages = [[Messages]]()
    
    // test
    let image1 = UIImage(named: "image1")
    let image2 = UIImage(named: "image2")
    let image3 = UIImage(named: "me")
    
    // test array
    var messagesFromServer = [
        Messages(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", createdAt: Date.dateString(customString: "1/05/2019"), isIncoming: true),
        Messages(text: "Message with email: developer.faris@gmail.com", createdAt: Date.dateString(customString: "1/05/2019"), isIncoming: true),
        Messages(text: "Hi", createdAt: Date.dateString(customString: "05/22/2019"), isIncoming: false),
        Messages(text: "Message with Phone Number: 4125388166", createdAt: Date.dateString(customString: "05/22/2019"), isIncoming: false),
        Messages(text: "Message with url: google.com", createdAt: Date.dateString(customString: "05/22/2019"), isIncoming: true),
        Messages(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,", createdAt: Date.dateString(customString: "05/22/2019"), isIncoming: false),
        Messages(text: "Lorem Ipsum is simply dummy text of the printing,", createdAt: Date.dateString(customString: "05/23/2019"), isIncoming: false),
         Messages(text: "Lorem Ipsum is simply dummy text of the printing,", createdAt: Date.dateString(customString: "05/23/2019"), isIncoming: true),
          Messages(text: "Lorem Ipsum is simply dummy text of the printing,", createdAt: Date.dateString(customString: "05/23/2019"), isIncoming: true),
        Messages(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,", createdAt: Date.dateString(customString: "05/23/2019"), isIncoming: true),
        
        Messages(image: UIImage(named: "me")!, createdAt: Date.dateString(customString: "05/25/2019"), isIncoming: true),
        
        
        Messages(image: UIImage(named: "image1")!, createdAt: Date.dateString(customString: "05/25/2019"), isIncoming: true),
        
        
        
    ]
    
    
  private lazy var tableView : UITableView = {
        let tbl = UITableView(frame: .zero, style: .grouped)
        tbl.backgroundColor = .clear
        tbl.separatorStyle = .none
        tbl.rowHeight = UITableView.automaticDimension
        tbl.estimatedRowHeight = 50
        tbl.delegate = self
        tbl.dataSource = self
        tbl.cellLayoutMarginsFollowReadableWidth = true
        tbl.contentInsetAdjustmentBehavior = .never
        tbl.allowsSelection = true
        tbl.keyboardDismissMode = keyboardDismissMode
        tbl.allowsMultipleSelection = false
        tbl.register(MessageTextCell.self, forCellReuseIdentifier: MessageTextCell.reuseIdentifier)
        tbl.register(MessageImageCell.self, forCellReuseIdentifier: MessageImageCell.reuseIdentifier)
        tbl.register(MessageCaptionCell.self, forCellReuseIdentifier: MessageCaptionCell.reuseIdentifier)
        
        return tbl
    }()
    
    
   private lazy var messageTextView: GrowingTextView = {
        let tex = GrowingTextView()
        tex.placeholder = "Message"
        tex.minHeight = 35
        tex.maxHeight = 130
        tex.layer.cornerRadius = 13
        tex.backgroundColor = .systemGray6
        tex.placeholderColor = .systemGray2
        tex.font = UIFont.systemFont(ofSize: 16)
        tex.enablesReturnKeyAutomatically = true
        tex.trimWhiteSpaceWhenEndEditing = true
        tex.tintColor = .black()
        tex.textContainerInset = .init(top: 7, left: 4, bottom: 7, right: 35)
        tex.delegate = self
        return tex
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "like_icon")?.withTintColor(.mainBlue), for: .normal)
        button.addTarget(self, action: #selector(didPressSendTextButton), for: UIControl.Event.touchUpInside)
        button.setDimensions(width: 25, height: 25)
        button.isEnabled = true
        button.tag = 0
        return button
     }()
    
    private var mediaButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "photo_icon")?.withTintColor(.mainBlue), for: .normal)
        button.addTarget(self, action: #selector(didPressSendFileButton), for: UIControl.Event.touchUpInside)
        button.setDimensions(width: 25, height: 25)
         return button
     }()
    
    private var audioButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "audio_icon")?.withTintColor(.mainBlue), for: .normal)
        button.addTarget(self, action: #selector(didPressSendAudioButton), for: UIControl.Event.touchUpInside)
        button.setDimensions(width: 25, height: 25)
         return button
     }()
    
    
    private var emojiButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "emoji_icon")?.withTintColor(.mainBlue), for: .normal)
        button.addTarget(self, action: #selector(didPressSendEmojiButton), for: UIControl.Event.touchUpInside)
        button.setDimensions(width: 25, height: 25)
         return button
     }()
    
    private var moreButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "more_icon")?.withTintColor(.mainBlue), for: .normal)
        button.addTarget(self, action: #selector(didPressSendMoreButton), for: UIControl.Event.touchUpInside)
        button.setDimensions(width: 25, height: 25)
         return button
     }()
    
    
    private var buttonView: UIView = {
         let buttonView = UIView()
         buttonView.backgroundColor = .clear
         buttonView.clipsToBounds = true
         return buttonView
     }()

    
    private var inputToolbar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private var quickEmojiV: quickEmojiView = {
        let view = quickEmojiView()
        view.backgroundColor = .clear
        return view
    }()
    
    
 
    var buttonViewLeftConstraint = NSLayoutConstraint()
     var textMore = true
    // variable
    private var imagePicker: ImagePicker!
    var parentViewController: UIViewController? = nil
    /// The layout guide for the keyboard
    private let keyboardLayoutGuide = KeyboardLayoutGuide()
    open var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .interactive {
           didSet {
               tableView.keyboardDismissMode = keyboardDismissMode
           }
       }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
        addObserver()
        
        
        MessagesViewModel.shared.GroupedMessages(Messages: messagesFromServer) { (messages) in
            self.messages = messages
            self.tableView.reloadData()
            DispatchQueue.main.async {
                let lastRow: Int = self.tableView.numberOfRows(inSection: self.messages.count - 1) - 1
                let indexPath = IndexPath(row: lastRow, section: self.messages.count - 1);
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupConstraints()
        self.imagePicker = ImagePicker(presentationController: parentViewController!, delegate: self)
        
    }

    
    
    // app Will Resign Active
    @objc private func WillResignActive() {}
    
    
    // app become Active
    @objc private func becomeActive() {}
    
    // app enter Background
    @objc private func enterBackground() {}
    
    
    
    // MARK: - SELECTIONS
    /// Send Text Button
    @objc private func didPressSendTextButton(_ sender: Any?) {
        if sendButton.tag == 0 {
            quickEmoji()
        } else if sendButton.tag == 1 {
            sendText()
        } else {
            removeQuickEmoji()
        }

    }
    
    /// send a quick Emoji
    private func quickEmoji() {
        self.addSubview(quickEmojiV)
        self.quickEmojiV.anchor(left: leftAnchor,bottom: inputToolbar.topAnchor,right: rightAnchor)
        self.quickEmojiV.transform = self.quickEmojiV.transform.scaledBy(x: 0, y: 0)
        self.sendButton.tag = 2
        let previouTransform =  sendButton.transform
        UIView.animate(withDuration: 0.2,animations: {
        self.sendButton.setBackgroundImage(UIImage(named: "cancel_icon")?.withTintColor(.mainBlue), for: .normal)
        self.sendButton.transform = self.sendButton.transform.scaledBy(x: 1.1, y: 1.1)
        self.quickEmojiV.transform  = .identity
        },completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.sendButton.transform  = previouTransform
                }
        })
        
        self.layoutIfNeeded()
    }
    
    /// remove a quick Emoji
    private func removeQuickEmoji() {
        sendButton.tag = 0
        let previouTransform =  sendButton.transform
        UIView.animate(withDuration: 0.2,animations: {
        self.sendButton.setBackgroundImage(UIImage(named: "like_icon")?.withTintColor(.mainBlue), for: .normal)
        self.sendButton.transform = self.sendButton.transform.scaledBy(x: 1.1, y: 1.1)
        self.quickEmojiV.transform = self.quickEmojiV.transform.scaledBy(x: 0.5, y: 0.5)
        },completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.quickEmojiV.transform = self.quickEmojiV.transform.scaledBy(x: 0.0, y: 0.0)
                self.quickEmojiV.removeFromSuperview()
                self.sendButton.transform  = previouTransform
                }
        })
        self.layoutIfNeeded()
    }
    
    /// send text message
    private func sendText() {
         let randomBool = Bool.random()
         let now = Date()
         let NewMessages = Messages(text: "\(messageTextView.text!)", createdAt: now, isIncoming: randomBool)
        
         
         let diff = Calendar.current.dateComponents([.day], from: now, to: ( messages.last?.last?.createdAt)!)
          if diff.day == 0 {
             MessagesViewModel.shared.object[self.messages.count - 1].append(NewMessages)
               self.messages[self.messages.count - 1].append(NewMessages)
               self.tableView.reloadData()
               DispatchQueue.main.async {
                   let lastRow: Int = self.tableView.numberOfRows(inSection: self.messages.count - 1) - 1
                   let indexPath = IndexPath(row: lastRow, section: self.messages.count - 1);
                   self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                   self.tableView.reloadRows(at: [indexPath], with: .none)
               }
             
         } else {
             MessagesViewModel.shared.object.insert([NewMessages], at: self.messages.count)
             self.messages.insert([NewMessages], at: self.messages.count)
             self.tableView.reloadData()
             DispatchQueue.main.async {
                 let lastRow: Int = self.tableView.numberOfRows(inSection: self.messages.count - 1) - 1
                 let indexPath = IndexPath(row: lastRow, section: self.messages.count - 1);
                 self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                 self.tableView.reloadRows(at: [indexPath], with: .none)
             }
         }

         // rest textview
         buttonViewLeftConstraint.constant = 10
         messageTextView.text = nil
         sendButton.tag = 0
         let previouTransform =  sendButton.transform
         UIView.animate(withDuration: 0.2,animations: {
         self.sendButton.setBackgroundImage(UIImage(named: "like_icon")?.withTintColor(.mainBlue), for: .normal)
         self.sendButton.transform = self.sendButton.transform.scaledBy(x: 1.1, y: 1.1)
         },completion: { _ in
             UIView.animate(withDuration: 0.2) {
                 self.sendButton.transform  = previouTransform
                 }
         })
         self.layoutIfNeeded()
    }
    
    /// Send file Button
    @objc private func didPressSendFileButton(_ sender: Any?) {
        self.imagePicker.present()
    }
       
    /// Send Emoji Button
    @objc private func didPressSendEmojiButton(_ sender: Any?) {}
    
    /// Send audio Button
    @objc private func didPressSendAudioButton(_ sender: Any?) {}
    
    /// Send More Button
    @objc private func didPressSendMoreButton(_ sender: Any?) {}
    
}

extension MessagesUI {

    private func setupUIElements() {
        // arrange subviews
        addSubview(tableView)
        tableView.contentInset = .init(top: 0, left: 0, bottom: -20, right: 0)
        
        addSubview(inputToolbar)
        inputToolbar.addSubview(messageTextView)
        inputToolbar.addSubview(sendButton)
        inputToolbar.addSubview(buttonView)
        inputToolbar.addSubview(audioButton)
        
        buttonView.addSubview(moreButton)
        buttonView.addSubview(mediaButton)
        buttonView.addSubview(emojiButton)
  
         // add constraints to inputToolbar
        addLayoutGuide(keyboardLayoutGuide)
        inputToolbar.anchor(top: tableView.bottomAnchor,left: leftAnchor,bottom: keyboardLayoutGuide.topAnchor,right: rightAnchor)
        buttonViewLeftConstraint = buttonView.leftAnchor.constraint(equalTo: inputToolbar.leftAnchor,constant: 10)
        buttonView.anchor(bottom: messageTextView.bottomAnchor
            ,paddingBottom: 5,width: 108,height: 25)
        buttonViewLeftConstraint.isActive = true
        
    }
    
    
    private func setupConstraints() {
        // add constraints to subviews

        tableView.anchor(top: safeAreaLayoutGuide.topAnchor,left: leftAnchor,right: rightAnchor)
    
        
        sendButton.anchor(bottom: messageTextView.bottomAnchor, right: inputToolbar.rightAnchor,paddingBottom: 5, paddingRight: 10)
        audioButton.anchor(bottom: messageTextView.bottomAnchor, right: messageTextView.rightAnchor,paddingBottom: 5, paddingRight: 5)
        
        
        messageTextView.anchor(top: inputToolbar.topAnchor,left: buttonView.rightAnchor,bottom: inputToolbar.bottomAnchor,right: sendButton.leftAnchor, paddingTop: 5,paddingLeft: 5,paddingBottom: 5,paddingRight: 5)
        

        moreButton.centerY(inView: buttonView,leftAnchor: buttonView.leftAnchor)
        mediaButton.centerY(inView: buttonView,leftAnchor: moreButton.rightAnchor,paddingLeft: 15)
        emojiButton.centerY(inView: buttonView,leftAnchor: mediaButton.rightAnchor,paddingLeft: 15)

       
        
    }
    
    // register observers
    private func addObserver() {
        /// app Enters Background
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: Notification.Name("appEntersBackground"), object: nil)
        
        /// app Becomes Active
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: Notification.Name("appBecomesActive"), object: nil)
        
        
        /// app Resign Active
        NotificationCenter.default.addObserver(self, selector: #selector(WillResignActive), name: Notification.Name("appResignActive"), object: nil)
        
        /// keyboard will Show
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // keyboard Will ChangeFrame ( hide / show )
    @objc open dynamic func keyboardWillShow(_ notification: Notification) {
           tableView.scrollToBottom(animated: false)
       }

}

extension MessagesUI: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, caption: String?) {
        guard let image = image else { return }
        let randomBool = Bool.random()
        let now = Date()
        var NewMessages: Messages!
        if caption == nil {
             NewMessages = Messages(image: image, createdAt: now, isIncoming: randomBool)
        } else {
             NewMessages = Messages(image: image, text: caption, createdAt: now, isIncoming: randomBool)
        }
        
        let diff = Calendar.current.dateComponents([.day], from: now, to: ( messages.last?.last?.createdAt)!)
          if diff.day == 0 {
             MessagesViewModel.shared.object[self.messages.count - 1].append(NewMessages)
               self.messages[self.messages.count - 1].append(NewMessages)
               self.tableView.reloadData()
               DispatchQueue.main.async {
                   let lastRow: Int = self.tableView.numberOfRows(inSection: self.messages.count - 1) - 1
                   let indexPath = IndexPath(row: lastRow, section: self.messages.count - 1);
                   self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                   self.tableView.reloadRows(at: [indexPath], with: .none)
               }
             
         } else {
             MessagesViewModel.shared.object.insert([NewMessages], at: self.messages.count)
             self.messages.insert([NewMessages], at: self.messages.count)
             self.tableView.reloadData()
             DispatchQueue.main.async {
                 let lastRow: Int = self.tableView.numberOfRows(inSection: self.messages.count - 1) - 1
                 let indexPath = IndexPath(row: lastRow, section: self.messages.count - 1);
                 self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                 self.tableView.reloadRows(at: [indexPath], with: .none)
             }
         }
    }
}


extension MessagesUI: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = messages[section].first {
            let date = Date()
            let dateString = MessagesViewModel.shared.chatTime(firstMessageInSection.createdAt, currentDate: date)
            let label = DateHeader()
            label.text = dateString
            
            let containerView = UIView()
            
            containerView.addSubview(label)
            label.center(inView: containerView)
            
            
            return containerView
            
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage = messages[indexPath.section][indexPath.row]
        let cellIdentifer = chatMessage.cellIdentifer()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! MessageCell
        let positionInBlock = MessagesViewModel.shared.getPositionInBlockForMessageAtIndex(indexPath.section, indexPath.row)

        // Update UI for cell
        if chatMessage.isIncoming {
            cell.updateLayoutForBubbleStyleIsIncoming(positionInBlock)
        } else {
            cell.updateLayoutForBubbleStyle(positionInBlock)
        }

        cell.bind(withMessage:  chatMessage)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let chatCell = cell as! MessageCell
        let chatMessage = messages[indexPath.section][indexPath.row]
        let positionInBlock = MessagesViewModel.shared.getPositionInBlockForMessageAtIndex(indexPath.section, indexPath.row)

        // Update UI for cell
        if chatMessage.isIncoming {
            chatCell.updateLayoutForBubbleStyleIsIncoming(positionInBlock)
        } else {
            chatCell.updateLayoutForBubbleStyle(positionInBlock)
        }
        
        //chatCell.layoutIfNeeded()
    }
    
}

extension MessagesUI: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the cell for the index of the model
        guard let cell = tableView.cellForRow(at: .init(row: indexPath.row, section: indexPath.section)) as? MessageCell else { return }
        let positionInBlock = MessagesViewModel.shared.getPositionInBlockForMessageAtIndex(indexPath.section, indexPath.row)
        switch positionInBlock {
        case .bottom, .single:
            /// the last row (date show always)
            cell.messageStatusView.isHidden = false
        default:
            if cell.messageStatusView.isHidden {
                 self.tableView.beginUpdates()
                 cell.messageStatusView.isHidden = false
                 self.tableView.endUpdates()
            } else {
                 self.tableView.beginUpdates()
                 cell.messageStatusView.isHidden = true
                 self.tableView.endUpdates()
            }
        }
        
        endEditing(true)
    }
    

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       // Get the cell for the index of the model
       guard let cell = tableView.cellForRow(at: .init(row: indexPath.row, section: indexPath.section)) as? MessageCell else { return }
       let positionInBlock = MessagesViewModel.shared.getPositionInBlockForMessageAtIndex(indexPath.section, indexPath.row)
       switch positionInBlock {
       case .bottom, .single:
            /// the last row (date show always)
           cell.messageStatusView.isHidden = false
       default:
            self.tableView.beginUpdates()
            cell.messageStatusView.isHidden = true
            self.tableView.endUpdates()
       }
        
    }
    
 
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = messages[indexPath.section][indexPath.row]
        let identifier = ["row": indexPath.row, "section": indexPath.section]
        switch item.type {
        case .text:
             return UIContextMenuConfiguration(identifier: identifier as NSCopying, previewProvider: nil) { _ -> UIMenu? in
                return self.TextContextMenu(text: item.text!)
            }
        case .file:
             return UIContextMenuConfiguration(identifier: identifier as NSCopying, previewProvider: nil) { _ -> UIMenu? in
                return self.ImageContextMenu()
            }
        case .sticker:
            print("sticker")
        case .map:
            print("map")
        case .audio:
            print("audio")
        case .caption:
            return UIContextMenuConfiguration(identifier: identifier as NSCopying, previewProvider: nil) { _ -> UIMenu? in
                return self.CaptionContextMenu(text: item.text!)
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

         // Ensure we can get the expected identifier
         guard let identifier = configuration.identifier as? [String : Int] else { return nil }

         print(configuration.identifier)
         // Get the current index of the identifier
         let row = identifier["row"]!
         let section = identifier["section"]!

         // Get the cell for the index of the model
         guard let cell = tableView.cellForRow(at: .init(row: row, section: section)) as? MessageCell else { return nil }

         // Since our preview has its own shape (a circle) we need to set the preview parameters
         // backgroundColor to clear, or we'll see a white rect behind it.
         let parameters = UIPreviewParameters()
         parameters.backgroundColor = .clear

         // Return a targeted preview using our cell previewView and parameters
         return UITargetedPreview(view: cell, parameters: parameters)
     }
    
    
    private func updateCell(row: Int,section: Int){
        let indexPath = NSIndexPath(row: row, section: section)
        tableView.beginUpdates()
        tableView.reloadRows(at: [(indexPath as IndexPath)], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
    }
    
}





extension MessagesUI: GrowingTextViewDelegate, UITextViewDelegate {
    
    
    // Mark: Keyboard Configure
    // while writing something
    func textViewDidChange(_ textView: UITextView) {
       /// disable button if entered has no text
        guard let text = textView.text else { return }
         if text.count == 0 {
            buttonViewLeftConstraint.constant = 10
            sendButton.tag = 0
            
            UIView.animate(withDuration: 0.2,animations: {
            self.sendButton.setBackgroundImage(UIImage(named: "like_icon")?.withTintColor(.mainBlue), for: .normal)
            self.sendButton.transform = self.sendButton.transform.scaledBy(x: 1.1, y: 1.1)
            },completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.sendButton.transform  = .identity
                    self.textMore = true
                    }
            })
            
             self.layoutIfNeeded()
         } else {
            buttonViewLeftConstraint.constant = -108
            sendButton.tag = 1
            if textMore == true {
                UIView.animate(withDuration: 0.2,animations: {
                self.sendButton.setBackgroundImage(UIImage(named: "send_icon")?.withTintColor(.mainBlue), for: .normal)
                self.sendButton.transform = self.sendButton.transform.scaledBy(x: 1.1, y: 1.1)
                },completion: { _ in
                    UIView.animate(withDuration: 0.2) {
                        self.sendButton.transform  = .identity
                        self.textMore = false
                        }
                })
            }

             self.layoutIfNeeded()
         }
            
            DispatchQueue.main.async {
                let lastRow: Int = self.tableView.numberOfRows(inSection: self.messages.count - 1) - 1
                let indexPath = IndexPath(row: lastRow, section: self.messages.count - 1);
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
     }
    
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.layoutIfNeeded()
            }, completion: { (completed) in
        })
    }
}


