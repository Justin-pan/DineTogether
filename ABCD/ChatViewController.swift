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
    let refreshControl = UIRefreshControl()
    var messageList: [Message] = []
    lazy var formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "eeee, h:m a"
        return formatter
    }()
    var roomName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async {
            if let room = roomManager.SharedInstance.roomList.first(where: {$0.roomName == self.roomName}){
                self.messageList = room.messageList
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom()
            }
        }
        addSocketHandlers()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        scrollsToBottomOnKeybordBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }
    @IBAction func goBackToParent(_ sender: Any){
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    func addSocketHandlers(){
        SocketIOManager.SharedInstance.defaultSocket.on("message"){[weak self] data, ack in
            if let room = roomManager.SharedInstance.roomList.first(where: {$0.roomName == data[0] as? String}){
                if let text: String = data[1] as? String, let id = data[2] as? String, let name = data[3] as? String, let date = data[4] as? String, let messageID = data[5] as? String{
                    let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                    let sender: Sender = Sender(id: id, displayName: name)
                    let sendDate = self?.formatter.date(from: date)
                    let message = Message(attributedText: attributedText, sender: sender, messageId: messageID, date: sendDate!)
                    room.messageList.insert(message, at: 0)
                }
            }else{
                
            }
            if(data[0] as? String == self?.roomName){
                if let text: String = data[1] as? String, let id = data[2] as? String, let name = data[3] as? String, let date = data[4] as? String, let messageID = data[5] as? String{
                    let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                    let sender: Sender = Sender(id: id, displayName: name)
                    let sendDate = self?.formatter.date(from: date)
                    let message = Message(attributedText: attributedText, sender: sender, messageId: messageID, date: sendDate!)
                    DispatchQueue.main.async {
                        self?.messageList.insert(message, at: 0)
                        self?.messagesCollectionView.reloadDataAndKeepOffset()
                        self?.refreshControl.endRefreshing()
                    }
                }
            }
        }
    }
}
extension ChatViewController: MessagesDataSource{
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func currentSender() -> Sender{
        let sender: Sender = Sender(id: userInfo.shared.email, displayName: userInfo.shared.fullName)
        return sender
    }
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

extension ChatViewController: MessagesDisplayDelegate{
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white: .darkText
    }
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

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

extension ChatViewController: MessageInputBarDelegate{
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
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
                SocketIOManager.SharedInstance.defaultSocket.emit("message", roomname, text, email, name, date, messageID)
            }
        }
    }
}
