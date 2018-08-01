//
//  Rooms.swift
//  ABCD
//
//  Created by admin on 7/25/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import Foundation

//classes to handle saving rooms and messages in these rooms
class roomManager{
    static let SharedInstance = roomManager()
    private init(){}
    var roomList: [rooms] = []
}

class rooms{
    var roomName: String
    var roomId: String
    var messageList: [Message] = []
    init(roomName: String, roomId: String){
        self.roomName = roomName
        self.roomId = roomId
    }
}
