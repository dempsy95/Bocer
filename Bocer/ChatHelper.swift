//
//  ChatHelper.swift
//  Bocer
//
//  Created by Dempsy on 2/15/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import CoreData
import UIKit

extension ChatViewController {
     func createMessageWithText(text: String, friend: Friend, date: Date) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = friend
            message.text = text
            message.toFriend = true
            message.date = date as NSDate?
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
}
