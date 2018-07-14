//
//  SocketManager.swift
//  ABCD
//
//  Created by jpa87 on 2018-07-14.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager{
    static let sharedInstance = SocketIOManager()
    var socket: SocketManager
    let defaultSocket: SocketIOClient
    let namespaceSocket: SocketIOClient
    private init(){
        self.socket = SocketManager(socketURL: URL(string: "https://radiant-lowlands-29508.herokuapp.com")!)
        self.defaultSocket = socket.socket(forNamespace: "/swift")
        self.namespaceSocket = socket.defaultSocket
    }
    
}
