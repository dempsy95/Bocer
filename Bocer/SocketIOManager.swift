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
    var socket = SocketIOClient(socketURL: URL(string: "ec2-50-18-202-224.us-west-1.compute.amazonaws.com:3000:8080")!, config: [.log(false), .forcePolling(true), .connectParams(["email" : UserInfoHelper().loadData().id!])])
    
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
            
            print("message: \(message)")
            print("dataString: \(dateString)")
            dateFormat.dateFormat = "yyyyMMddhhmmss"
            let date = dateFormat.date(from: dateString!)
            
            print("date: \(date)")
            
            DatabaseHelper().createMessageWithText(text: message!, friend: friend!, toFriend: false, hasRead: false, date: date!)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callMessageUpdateNotification"), object: [friend])
        }
        
        socket.on("messages") { dataArray, ack in
            let mData = dataArray[0] as? [String: AnyObject]
            let messages = mData?["from"] as! [[String: AnyObject]]
            for data in messages {
                let fromid = data["from"] as! String?
                let friend = DatabaseHelper().findFriend(id: fromid)
                
                let message = data["message"] as! String?
                let image = data["image"] as! String?
                let dateString = data["date"] as! String?
                let dateFormat = DateFormatter()
                
                dateFormat.dateFormat = "yyyyMMddhhmmss"
                let date = dateFormat.date(from: dateString!)
                                
                DatabaseHelper().createMessageWithText(text: message!, friend: friend!, toFriend: false, hasRead: false, date: date!)
                NotificationCenter.default
                    .post(name: Notification.Name(rawValue: "callMessageUpdateNotification"), object: [friend])
            }
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
