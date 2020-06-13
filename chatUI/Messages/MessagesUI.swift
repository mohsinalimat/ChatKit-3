//
//  MessagesUI.swift
//  chatUI
//
//  Created Faris Albalawi on 4/17/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.


import UIKit

@objc protocol inputDelegate {
    @objc optional func sendText(text: String)
    @objc optional func SendImage(image: UIImage, caption: String?)
    @objc optional func SendAudio(url: URL)
    @objc optional func SendEmoji(emoji: String)
}

class MessagesUI : UIView {
 
  /// The data source for the messenger
  public weak var dataSource: DataSource?
  public weak var inputDelegate: inputDelegate?
    
    public var currentUser: User!
    
   lazy var tableView : UITableView = {
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
        tbl.register(MessageEmojiCell.self, forCellReuseIdentifier: MessageEmojiCell.reuseIdentifier)
        tbl.register(MessageAudioCell.self, forCellReuseIdentifier: MessageAudioCell.reuseIdentifier)
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

    
     var  lineboardView: UIView = {
         let lineboardView = UIView()
         lineboardView.backgroundColor = .systemGray6
         return lineboardView
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
    
    private var recordAudioView: recordAudio = {
        let view = recordAudio()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    

   private var buttonViewLeftConstraint = NSLayoutConstraint()
   private var textMore = true
   private var isKeybordShowing = false
   private var isAudioViewShowing = false
   private var keyboardHeight = CGFloat()
    
    // variable
    private var imagePicker: ImagePicker!
    var parentViewController: UIViewController? = nil
    /// The layout guide for the keyboard
    private let keyboardLayoutGuide = KeyboardLayoutGuide()
    private var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .interactive {
           didSet {
               tableView.keyboardDismissMode = keyboardDismissMode
           }
       }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
        addObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        keyboardHeight = KeyboardService.keyboardHeight()
        print(keyboardHeight)
        setupConstraints()
        self.imagePicker = ImagePicker(presentationController: parentViewController!, delegate: self)
        
    }

    
    // MARK: - SELECTIONS
    /// Send Text Button
    @objc private func didPressSendTextButton(_ sender: Any?) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
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
        quickEmojiV.delegate = self
        self.quickEmojiV.anchor(left: leftAnchor,bottom: stackView.topAnchor,right: rightAnchor,paddingBottom: 2)
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
        self.quickEmojiV.transform = self.quickEmojiV.transform.scaledBy(x: 0.1, y: 0.1)
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
         self.textMore = true
         self.inputDelegate?.sendText?(text: messageTextView.text!)

         /// rest textview
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
        self.endEditing(true)
        self.imagePicker.present()
    }
       
    /// Send Emoji Button
    @objc private func didPressSendEmojiButton(_ sender: Any?) {}
    
    /// Send audio Button
    @objc private func didPressSendAudioButton(_ sender: Any?) {
        self.sendButton.currentBackgroundImage?.withTintColor(.systemGray6)
        self.sendButton.isEnabled = false
        self.emojiButton.currentBackgroundImage?.withTintColor(.systemGray6)
        self.emojiButton.isEnabled = false
        self.mediaButton.currentBackgroundImage?.withTintColor(.systemGray6)
        self.mediaButton.isEnabled = false
        self.moreButton.currentBackgroundImage?.withTintColor(.systemGray6)
        self.moreButton.isEnabled = false

        
        
       if isKeybordShowing {
            self.recordAudioView.isHidden = false
            self.endEditing(true)
            self.tableView.scrollToBottomRow(animated: false)
            self.layoutIfNeeded()
            
        } else {
            self.recordAudioView.isHidden = false
            self.tableView.scrollToBottomRow(animated: false)
            UIView.animate(withDuration: 0.3) {
             self.layoutIfNeeded()
          }
          
        }

        
    }
    
    
    private func restButton() {
        self.sendButton.currentBackgroundImage?.withTintColor(.mainBlue)
        self.sendButton.isEnabled = true
        self.emojiButton.currentBackgroundImage?.withTintColor(.mainBlue)
        self.emojiButton.isEnabled = true
        self.mediaButton.currentBackgroundImage?.withTintColor(.mainBlue)
        self.mediaButton.isEnabled = true
        self.moreButton.currentBackgroundImage?.withTintColor(.mainBlue)
        self.moreButton.isEnabled = true
        self.audioButton.currentBackgroundImage?.withTintColor(.mainBlue)
        self.audioButton.isEnabled = true
    }
    
    /// Send More Button
    @objc private func didPressSendMoreButton(_ sender: Any?) {}
    
}

extension MessagesUI {

    private func setupUIElements() {
        addSubview(tableView)
        tableView.contentInset = .init(top: 0, left: 0, bottom: -20, right: 0)
        
        addSubview(stackView)
        stackView.addArrangedSubview(lineboardView)
        stackView.addArrangedSubview(inputToolbar)
        stackView.addArrangedSubview(recordAudioView)
      
        recordAudioView.delegate = self
    
        inputToolbar.addSubview(messageTextView)
        inputToolbar.addSubview(sendButton)
        inputToolbar.addSubview(buttonView)
        inputToolbar.addSubview(audioButton)
        
        buttonView.addSubview(moreButton)
        buttonView.addSubview(mediaButton)
        buttonView.addSubview(emojiButton)

    }
    
    
    private func setupConstraints() {

        let height = self.safeAreaInsets.bottom
        recordAudioView.anchor(left: stackView.leftAnchor,right:stackView.rightAnchor,height:keyboardHeight - height)
        inputToolbar.anchor(left: stackView.leftAnchor,right:stackView.rightAnchor)
        recordAudioView.isHidden = true
        lineboardView.anchor(left: stackView.leftAnchor,right:stackView.rightAnchor)
        let lineboardViewHeight = lineboardView.heightAnchor.constraint(equalToConstant: 0)
        lineboardViewHeight.isActive = true
        lineboardViewHeight.constant = 1
     
 
        
        addLayoutGuide(keyboardLayoutGuide)
    
        stackView.anchor(top: tableView.bottomAnchor,left: leftAnchor,bottom: keyboardLayoutGuide.topAnchor,right: rightAnchor)
    
        buttonViewLeftConstraint = buttonView.leftAnchor.constraint(equalTo: inputToolbar.leftAnchor,constant: 10)
        buttonView.anchor(bottom: messageTextView.bottomAnchor
               ,paddingBottom: 5,width: 108,height: 25)
        buttonViewLeftConstraint.isActive = true
        
        
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
        /// keyboard will Show
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        /// keyboard will Show
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // keyboard Will show
    @objc open dynamic func keyboardWillShow(_ notification: Notification) {
           self.restButton()
           self.isKeybordShowing = true
           self.recordAudioView.isHidden = true
           self.tableView.scrollToBottomRow(animated: false)
        
       }

    // keyboard Will hide
    @objc open dynamic func keyboardWillHide(_ notification: Notification) {
         self.isKeybordShowing = false
       }
    
    
}

extension MessagesUI: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let message = dataSource?.headerTitle(for: section) else {
                   fatalError("Message not defined for \(section)")
            }
        
        if let firstMessageInSection = message.first {
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
       return dataSource?.numberOfMessages(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chatMessage = dataSource?.message(for: indexPath) else {
                 fatalError("Message not defined for \(indexPath)")
             }
        let cellIdentifer = chatMessage.cellIdentifer()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! MessageCell
        let positionInBlock = MessagesViewModel.shared.getPositionInBlockForMessageAtIndex(indexPath.section, indexPath.row)

        // Update UI for cell
        if chatMessage.user.userId != currentUser.userId  {
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
        guard let Message = dataSource?.message(for: indexPath) else {
                 fatalError("Message not defined for \(indexPath)")
             }
        
        let chatMessage = Message
        let positionInBlock = MessagesViewModel.shared.getPositionInBlockForMessageAtIndex(indexPath.section, indexPath.row)

        // Update UI for cell
        if chatMessage.user.userId != currentUser.userId {
            chatCell.updateLayoutForBubbleStyleIsIncoming(positionInBlock)
        } else {
            chatCell.updateLayoutForBubbleStyle(positionInBlock)
        }
        
        //chatCell.layoutIfNeeded()
    }
    
}

extension MessagesUI: quickEmojiDelegate, recordDelegate {
    func AudioFile(_ url: URL) {
        self.messageTextView.becomeFirstResponder()
        self.inputDelegate?.SendAudio?(url: url)
    }
    
    func EmojiTapped(index: Int) {
        self.inputDelegate?.SendEmoji?(emoji: quickEmojiV.quickEmojiArray[index])
 
         // rest view
         sendButton.tag = 0
         let previouTransform =  sendButton.transform
         UIView.animate(withDuration: 0.2,animations: {
         self.sendButton.setBackgroundImage(UIImage(named: "like_icon")?.withTintColor(.mainBlue), for: .normal)
         self.sendButton.transform = self.sendButton.transform.scaledBy(x: 1.1, y: 1.1)
         self.quickEmojiV.transform = self.quickEmojiV.transform.scaledBy(x: 0.1, y: 0.1)
         },completion: { _ in
             UIView.animate(withDuration: 0.2) {
                 self.quickEmojiV.transform = self.quickEmojiV.transform.scaledBy(x: 0.0, y: 0.0)
                 self.quickEmojiV.removeFromSuperview()
                 self.sendButton.transform  = previouTransform
                 }
         })
         self.layoutIfNeeded()
    }

}

extension MessagesUI: ImagePickerDelegate {
    func didSelect(image: UIImage?, caption: String?) {
        guard let image = image else { return }
        self.inputDelegate?.SendImage?(image: image, caption: caption)
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

     }
    
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.layoutIfNeeded()
            }, completion: { (completed) in
        })
    }
}
