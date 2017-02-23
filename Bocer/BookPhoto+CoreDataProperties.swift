//
//  BookPhoto+CoreDataProperties.swift
//  Bocer
//
//  Created by Dempsy on 2/22/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import Foundation
import CoreData


extension BookPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookPhoto> {
        return NSFetchRequest<BookPhoto>(entityName: "BookPhoto");
    }

    @NSManaged public var photo: NSData?
    @NSManaged public var nth: Int16
    @NSManaged public var book: Book?

}
