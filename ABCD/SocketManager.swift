//
//  SocketManager.swift
//  ABCD
//
//  Created by admin on 7/25/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager{
    static let SharedInstance = SocketIOManager()
    var socket: SocketManager
    let defaultSocket: SocketIOClient
    private init(){
        self.socket = SocketManager(socketURL: URL(string: "https://damp-retreat-61858.herokuapp.com")!)
        self.defaultSocket = socket.defaultSocket
    }
}
