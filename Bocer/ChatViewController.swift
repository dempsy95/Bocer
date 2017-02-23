//
//  ChatViewController.swift
//  SwiftExample
//
//  Created by Dan Leonard on 5/11/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
// MARK: 
// senderID is different from senderDisplayName
// senderID is the user's ID
// senderDisplayName is the name of the friend who the user is talking to

import UIKit
import JSQMessagesViewController
import Alamofire
import SwiftyJSON

class ChatViewController: JSQMessagesViewController {
    var friend: Friend? {
        didSet {
            //import data from core data
            var mMessages = friend?.messages?.allObjects as! [Message]
            mMessages = mMessages.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
            for message in mMessages {
                var currentID = "", currentName = ""
                if message.toFriend == false {
                    currentID = (friend?.id)!
                    currentName = (friend?.name)!
                } else {
                    currentID = self.senderId()
                    currentName = self.senderDisplayName()
                }
                messages.append(JSQMessage(senderId: currentID, senderDisplayName: currentName, date: message.date as! Date, text: message.text!))
            }
            DatabaseHelper().readMessage(id: (friend?.id)!)
        }
    }
    var messages = [JSQMessage]()
    private var incomingBubble: JSQMessagesBubbleImage!
    private var outgoingBubble: JSQMessagesBubbleImage!
    
    var myUserID: String!
    var myDisplayName: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavButton()
        self.view.layer.contentsRect = CGRect(x: 0, y: 64, width: self.view.layer.contentsRect.width, height: self.view.layer.contentsRect.height - 64)
        // Make taillessBubbles
        incomingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero, layoutDirection: UIApplication.shared.userInterfaceLayoutDirection).incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        outgoingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero, layoutDirection: UIApplication.shared.userInterfaceLayoutDirection).outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        
        //showing avatar for users
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        
        
        //MARK: beta feature, may not stable
//        collectionView?.collectionViewLayout.springinessEnabled = false
        
        //to be decided
        automaticallyScrollsToMostRecentMessage = true
        
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        
        //add notification listener for socket
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleCallMessageUpdateNotification(_:)), name: NSNotification.Name(rawValue: "callMessageUpdateNotification"), object: nil)
    }
    
    //TODO:
    //update the collection view when a message recevied
    private func messageReceived() {
        //Show the typing indicator to be shown
        self.showTypingIndicator = !self.showTypingIndicator
        
        //scroll to actually view the indicator
        self.scrollToBottom(animated: true)
        
        
    }
    
    // MARK: JSQMessagesViewController method overrides
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(message)
        DatabaseHelper().createMessageWithText(text: text, friend: friend!, toFriend: true, hasRead: true, date: date)
        self.finishSendingMessage(animated: true)
 
        //Mark: This part is only for NSAttributedString?
        /**
        *  Upon receiving a message, you should:
        *
        *  1. Play sound (optional)
        *  2. Add new JSQMessageData object to your data source
        *  3. Call `finishReceivingMessage`
        */
//
//        let newMessage = JSQMessage(senderId: "nobody", senderDisplayName: "nobody", date: date, text: text)
//        self.messages.append(newMessage)
//        self.finishReceivingMessage(animated: true)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)

    }
    
    private func setupNavButton() {
        let mImage = UIImage(named: "back")
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        btn.setImage(mImage, for: .normal)
        btn.addTarget(self, action: #selector(ChatViewController.didCancel), for: .touchUpInside)
        btn.tintColor = UIColor.white
        let btnItem = UIBarButtonItem(customView: btn)
        navigationItem.leftBarButtonItem = btnItem
        navigationItem.title = self.senderDisplayName()
    }
    
    @objc private func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: JSQMessages CollectionView DataSource
    
    override func senderId() -> String {
        return myUserID
    }
    
    override func senderDisplayName() -> String {
        return myDisplayName
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        if messages[indexPath.item].senderId == self.senderId() {
            return outgoingBubble
        } else {
            return incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[indexPath.item]
        //TODO: get avatar
        let myAvatar = JSQMessagesAvatarImageFactory().avatarImage(withUserInitials: "DL", backgroundColor: UIColor.jsq_messageBubbleGreen(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12))
        let anotherAvatar = JSQMessagesAvatarImageFactory().avatarImage(withPlaceholder: UIImage(named: "sample_avatar")!)
        return anotherAvatar
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: (message.date))
        }
        
        let messageNow = self.messages[indexPath.item]
        let messagePre = self.messages[indexPath.item - 1]
        let elapsed = messageNow.date.timeIntervalSince(messagePre.date)
        if (elapsed > 120) {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: (messageNow.date))
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        // Displaying names above messages
        //Mark: Removing Sender Display Name
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         */
        
        //Mark: for now we do not need to display sender name
            return nil
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item  == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        let messageNow = self.messages[indexPath.item]
        let messagePre = self.messages[indexPath.item - 1]
        let elapsed = messageNow.date.timeIntervalSince(messagePre.date)
        if (elapsed > 120) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         */
        
        //Mark: for now we do not need to display sender name
            return 0.0
        
        /**
         *  iOS7-style sender name labels
         */
//        let currentMessage = self.messages[indexPath.item]
//        
//        if currentMessage.senderId == self.senderId {
//            return 0.0
//        }
//        
//        if indexPath.item - 1 > 0 {
//            let previousMessage = self.messages[indexPath.item - 1]
//            if previousMessage.senderId == currentMessage.senderId {
//                return 0.0
//            }
//        }
//        
//        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    func handleCallMessageUpdateNotification(_ notification: Notification) {
        if let data = notification.object as? Friend {
            if data == friend {
                let newMessages = DatabaseHelper().catchUnreadMessages(friend: friend!)
                for message in newMessages {
                    let newMessage = JSQMessage(senderId: (friend?.id)!, senderDisplayName: (friend?.name)!, date: message.date as! Date, text: message.text!)
                    self.messages.append(newMessage)
                }
                self.finishReceivingMessage(animated: true)
            }
        }
    }

}
