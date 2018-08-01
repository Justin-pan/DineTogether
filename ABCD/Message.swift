//
//  Message.swift
//  ABCD
//
//  Created by admin on 7/25/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import Foundation
import MessageKit
//Message struct for initializing new messages
struct Message: MessageType {
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: Sender, sentDate: Date, messageId: String){
        self.kind = kind
        self.sender = sender
        self.sentDate = sentDate
        self.messageId = messageId
    }
    init(text: String, sender: Sender, messageId: String, date: Date){
        self.init(kind: .text(text), sender: sender, sentDate: date, messageId: messageId)
    }
    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, sentDate: date, messageId: messageId)
    }
    init(emoji: String, sender: Sender, messageId: String, date: Date){
        self.init(kind: .emoji(emoji), sender: sender, sentDate: date, messageId: messageId)
    }
}
