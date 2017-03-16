//
//  Card+CoreDataProperties.swift
//  Bocer
//
//  Created by Dempsy on 3/15/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card");
    }

    @NSManaged public var number: String?
    @NSManaged public var month: Int64
    @NSManaged public var year: Int64
    @NSManaged public var cvv: Int64

}
