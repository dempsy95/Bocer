//
//  SocketIOManager.swift
//  Bocer
//
//  Created by Dempsy on 2/19/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import Foundation
import SocketIO
import JSQMessagesViewController

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket = SocketIOClient(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .forcePolling(true), .connectParams(["email" : UserInfoHelper().loadData().id!])])
    
    override init() {
        super.init()
        
        socket.on("message") { dataArray, ack in
            let data = dataArray[0] as? [String: AnyObject]
            let fromid = data?["from"] as! String?
            let friend = DatabaseHelper().findFriend(id: fromid)
            let message = data?["message"] as! String?
            let image = data?["image"] as! String?
            let dateString = data?["date"] as! String?
            let dateFormat = DateFormatter()
            dateFormat.setLocalizedDateFormatFromTemplate("yyyy MM dd-HH:mm:ss")
            let date = dateFormat.date(from: dateString!)
            DatabaseHelper().createMessageWithText(text: message!, friend: friend!, toFriend: false, hasRead: false, date: date!)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callMessageUpdateNotification"), object: [friend])
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
