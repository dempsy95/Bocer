//
//  Book+CoreDataProperties.swift
//  Bocer
//
//  Created by Dempsy on 2/17/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book");
    }

    @NSManaged public var bookID: String?
    @NSManaged public var ownerID: String?
    @NSManaged public var comment: String?
    @NSManaged public var wellness: Int16
    @NSManaged public var edition: Int16
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension Book {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: BookPhoto)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: BookPhoto)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
