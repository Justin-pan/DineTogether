//
//  ChatViewController.swift
//  ABCD
//
//  Created by jpa87 on 7/13/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import Foundation
import MessageKit
import SocketIO

class ChatViewController: MessagesViewController{
    let refreshControl = UIRefreshControl()
    var messageList: [Message] = []
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}
