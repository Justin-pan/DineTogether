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
        return formatter
    }()
    
}
extension ChatViewController: MessagesDataSource{
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func currentSender() -> Sender{
        var sender: Sender = Sender(id: userInfo.shared.email, displayName: userInfo.shared.fullName)
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
