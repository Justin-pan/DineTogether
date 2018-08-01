//
//  ChatViewController.swift
//  ABCD
//
//  Created by jpa87 on 7/13/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import Foundation
import MessageKit

class ChatViewController: MessagesViewController{
    //View Controller for messaging system
    //properties are all used for creating message objects and naming the room
    var messageList: [Message] = []
    lazy var formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "eeee, h:mm a"
        return formatter
    }()
    var roomName: String = ""
    var roomId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //syncing stored messages with current view controller messages
        DispatchQueue.global(qos: .userInitiated).async {
            if let room = roomManager.SharedInstance.roomList.first(where: {$0.roomName == self.roomName}){
                DispatchQueue.main.async {
                    self.messageList = room.messageList
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }else{
                DispatchQueue.main.async{
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        }
        //The documentation says that the delegates for each of these properties is required to be the current view controller
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        scrollsToBottomOnKeybordBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        //creating the navigation bar that will have the room title
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        navigationBar.barTintColor = UIColor.lightGray
        let button = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBackToParent(_:)))
        let navigationItem = UINavigationItem(title: roomId + "'s room")
        navigationItem.leftBarButtonItem = button
        navigationBar.items = [navigationItem]
        //self.view.addSubview(navigationBar)
        /*if SYSTEM_VERSION_LESS_THAN(version: "11.0") {
         self.messagesCollectionView.contentInset = UIEdgeInsetsMake(59, 0, 0, 10)
         } else {
         self.messagesCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 10)
         }*/
        addSocketHandlers()
    }
    //This handles the offset of the navigation bar, only handled in versions higher than 11.0
    /*func SYSTEM_LESS_THAN_VERSION(version: String) -> Bool{
        return UIDevice.current.systemVersion.compare(
            version,
            options: NSString.CompareOptions.numeric
        ) == ComparisonResult.orderedAscending
    }*/
    //button function that handles going back to parent view controller
    @objc func goBackToParent(_ sender: UIBarButtonItem!){
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    //socket handlers that adds messages to the current view controller messagelist, not just the stored messagelist avaiable
    func addSocketHandlers(){
        SocketIOManager.SharedInstance.defaultSocket.on("message"){[weak self] data, ack in
            /*if let room = roomManager.SharedInstance.roomList.first(where: {$0.roomName == data[0] as? String}){
                if let text: String = data[1] as? String, let id = data[2] as? String, let name = data[3] as? String, let date = data[4] as? String, let messageID = data[5] as? String{
                    let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                    let sender: Sender = Sender(id: id, displayName: name)
                    let sendDate = self?.formatter.date(from: date)
                    let message = Message(attributedText: attributedText, sender: sender, messageId: messageID, date: sendDate!)
                    room.messageList.append(message)
                }
            }else{
                
            }*/
            if(data[0] as? String == self?.roomName){
                if let text: String = data[1] as? String, let id = data[2] as? String, let name = data[3] as? String, let date = data[4] as? String, let messageID = data[5] as? String{
                    let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                    let sender: Sender = Sender(id: id, displayName: name)
                    let sendDate = self?.formatter.date(from: date)
                    let message = Message(attributedText: attributedText, sender: sender, messageId: messageID, date: sendDate!)
                    DispatchQueue.main.async {
                        self?.messageList.append(message)
                        self?.messagesCollectionView.insertSections([(self?.messageList.count)! - 1])
                        self?.messagesCollectionView.scrollToBottom()
                    }
                }
            }
        }
    }
}
//UI functions that handle the display of the message
extension ChatViewController: MessagesDataSource{
    //This function handles which message is at which area on the screen
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    //Returns how many messages there are
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    //The current sender is used to handle logic based on current sender and not current sender
    func currentSender() -> Sender{
        let sender: Sender = Sender(id: userInfo.shared.email, displayName: userInfo.shared.fullName)
        return sender
    }
    //displays name of sender on top of the message
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    //displays send date of message below message
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}
//UI functions that handle the display of message based on sender
extension ChatViewController: MessagesDisplayDelegate{
    //text colour changes based on current sender or not
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white: .darkText
    }
    //message background changes based on sender logic
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    //the speech bubble trail side changes based on sender logic
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    //removing avatar view because handling images requires much more server power, which we do not have available to us
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
        }
    }
}
//handling label size
extension ChatViewController: MessagesLayoutDelegate{
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0{
            return 10
        }
        return 0
    }
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}
//function to handle user input
extension ChatViewController: MessageInputBarDelegate{
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //takes components from the input bar and creates messages based on them
        for component in inputBar.inputTextView.components{
            if let text = component as? String{
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                let roomname = roomName
                let email = currentSender().id
                let name = currentSender().displayName
                let date = formatter.string(from: Date())
                let messageID = UUID().uuidString
                let message = Message(attributedText: attributedText, sender: currentSender(), messageId: messageID, date: Date())
                messageList.append(message)
                messagesCollectionView.insertSections([messageList.count - 1])
                messagesCollectionView.scrollToBottom()
                inputBar.inputTextView.text = ""
                if let room = roomManager.SharedInstance.roomList.first(where: {$0.roomName == roomName}){
                    room.messageList.append(message)
                }
                SocketIOManager.SharedInstance.defaultSocket.emit("message", roomname, text, email, name, date, messageID)
            }
        }
    }
}
