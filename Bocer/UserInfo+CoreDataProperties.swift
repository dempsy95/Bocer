//
//  UserInfo+CoreDataProperties.swift
//  Bocer
//
//  Created by Dempsy on 2/16/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo");
    }

    @NSManaged public var id: String?
    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var password: String?
    @NSManaged public var address: String?
    @NSManaged public var college: String?
    @NSManaged public var avatar: NSData?
    @NSManaged public var full_avatar: NSData?
    @NSManaged public var email: String?

}
