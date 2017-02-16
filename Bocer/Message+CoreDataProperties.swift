//
//  Message+CoreDataProperties.swift
//  Bocer
//
//  Created by Dempsy on 2/15/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var text: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var toFriend: Bool
    @NSManaged public var friend: Friend?

}
