//
//  Rooms.swift
//  ABCD
//
//  Created by admin on 7/25/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import Foundation


class roomManager{
    static let SharedInstance = roomManager()
    private init(){}
    var roomList: [rooms] = []
}

class rooms{
    var roomName: String
    var messageList: [Message] = []
    init(roomName: String){
        self.roomName = roomName
    }
}
