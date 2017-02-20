//
//  SocketIOManager.swift
//  Bocer
//
//  Created by Dempsy on 2/19/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket = SocketIOClient(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .forcePolling(true), .connectParams(["email" : UserInfoHelper().loadData().id!])])
    
    override init() {
        super.init()
        
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
