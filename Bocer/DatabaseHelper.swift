//
//  MessengerHelper.swift
//  Bocer
//
//  Created by Dempsy on 2/15/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DatabaseHelper {
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
                    }
                }
                
                try(context.save())
                
                
            } catch let err {
                print(err)
            }
            
        }
    }
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "sample_avatar"
            mark.id = "mark"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = mark
            message.text = "Hello, my name is Mark. Nice to meet you..."
            message.toFriend = false
            message.hasRead = false
            message.date = NSDate()
            
            let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            steve.name = "Steve Jobs"
            steve.profileImageName = "sample_avatar"
            steve.id = "steve"
            
            createMessageWithText(text: "Good morning..", friend: steve, minutesAgo: 3, toFriend: true, context: context)
            createMessageWithText(text: "Hello, how are you?", friend: steve, minutesAgo: 2, toFriend: false, context: context)
            createMessageWithText(text: "Are you interested in buying an Apple device?", friend: steve, minutesAgo: 1, toFriend: false, context: context)
            
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "sample_avatar"
            donald.id = "donald"
            
            createMessageWithText(text: "You're fired", friend: donald, minutesAgo: 5, toFriend: false, context: context)
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
        
    }
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, toFriend: Bool, context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.toFriend = toFriend
        message.hasRead = true
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
    }
    
    func loadData() -> [Message]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        var messages : [Message]?

        if let context = delegate?.managedObjectContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
//                    print(friend.name)
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        
                        let fetchedMessages = try(context.fetch(fetchRequest)) as? [Message]
                        messages?.append(contentsOf: fetchedMessages!)
                        
                    } catch let err {
                        print(err)
                    }
                }
                
                messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
                
            }
        }
        return messages
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.managedObjectContext {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do {
                
                return try context.fetch(request) as? [Friend]
                
            } catch let err {
                print(err)
            }
            
        }
        
        return nil
    }
    
    func createMessageWithText(text: String, friend: Friend, date: Date) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = friend
            message.text = text
            message.toFriend = true
            message.hasRead = true
            message.date = date as NSDate?
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func deleteFriend(id: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.managedObjectContext {
            
            do {
                let fetchMessageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                let messages = try(context.fetch(fetchMessageRequest)) as? [Message]
                for message in messages! {
                    if message.friend?.id == id {
                        context.delete(message)
                    }
                }
                
                let fetchFriendRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
                let friends = try(context.fetch(fetchFriendRequest)) as? [Friend]
                for friend in friends! {
                    if friend.id == id {
                        context.delete(friend)
                    }
                    break
                }
                
                try(context.save())
                
                
            } catch let err {
                print(err)
            }
        }
    }
    
    func readMessage(id: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let fetchMessageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                let messages = try(context.fetch(fetchMessageRequest)) as? [Message]
                for message in messages! {
                    if message.friend?.id == id {
                        message.hasRead = true
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
}
