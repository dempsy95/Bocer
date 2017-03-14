//
//  BookInfoHelper.swift
//  Bocer
//
//  Created by Dempsy on 2/22/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BookInfoHelper {
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let entityNames = ["Book", "BookPhoto"]
                
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
            
            let book1 = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
            book1.bookID = "idforbook1"
            book1.comment = "A very nice story"
            book1.edition = 11
            book1.ownerID = "mark"
            book1.wellness = 4
            book1.googleID = "somegoogleid"
            book1.title = "Selected Stories from Lu Hsun"
            book1.author = "Lu Hsun"
            book1.publisher = "Pearson"
            book1.forMain = true
            book1.sellerPrice = 12
            book1.buyerPrice = 15
            
            let photo1 = NSEntityDescription.insertNewObject(forEntityName: "BookPhoto", into: context) as! BookPhoto
            photo1.photo = UIImageJPEGRepresentation(UIImage(named: "book_image")!, 1) as NSData?
            photo1.book = book1
            photo1.nth = 0
            let photo2 = NSEntityDescription.insertNewObject(forEntityName: "BookPhoto", into: context) as! BookPhoto
            photo2.photo = UIImageJPEGRepresentation(UIImage(named: "book_image_2")!, 1) as NSData?
            photo2.book = book1
            photo2.nth = 1
            
            let book2 = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
            book2.bookID = "idforbook2"
            book2.comment = "A very nice drama"
            book2.edition = 5
            book2.ownerID = "steve"
            book2.wellness = 3
            book2.googleID = "somegoogleid2"
            book2.title = "A Streetcar Named Desire"
            book2.author = "I Forgot"
            book2.publisher = "Pearson"
            book2.forMain = true
            book2.sellerPrice = 10
            book2.buyerPrice = 12
            
            let photo3 = NSEntityDescription.insertNewObject(forEntityName: "BookPhoto", into: context) as! BookPhoto
            photo3.photo = UIImageJPEGRepresentation(UIImage(named: "book_image_2")!, 1) as NSData?
            photo3.book = book2
            photo3.nth = 0
            let photo4 = NSEntityDescription.insertNewObject(forEntityName: "BookPhoto", into: context) as! BookPhoto
            photo4.photo = UIImageJPEGRepresentation(UIImage(named: "book_image_3")!, 1) as NSData?
            photo4.book = book2
            photo3.nth = 1
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    func loadData() -> [Book]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        var res = [Book]()
        
        if let context = delegate?.managedObjectContext {
            do {
                let fetchMessageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
                let books = try(context.fetch(fetchMessageRequest)) as? [Book]
                for book in books! {
                    if book.ownerID == UserInfoHelper().loadData().id {
                        res.append(book)
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        return res
    }
    
    func getFirstImage(book: Book) -> BookPhoto? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            do {
                let fetchMessageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookPhoto")
                let photos = try(context.fetch(fetchMessageRequest)) as? [BookPhoto]
                for photo in photos! {
                    if photo.book == book && photo.nth == 0 {
                        return photo
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        return nil
    }
    
    func getImages(book: Book) -> [BookPhoto]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        var res = [BookPhoto]()
        
        if let context = delegate?.managedObjectContext {
            do {
                let fetchMessageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookPhoto")
                fetchMessageRequest.sortDescriptors = [NSSortDescriptor(key: "nth", ascending: true)]
                let photos = try(context.fetch(fetchMessageRequest)) as? [BookPhoto]
                for photo in photos! {
                    if photo.book == book {
                        res.append(photo)
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        return res
    }
    
    func getBookInfo(bookID: String) -> Book? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            do {
                let fetchMessageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
                let books = try(context.fetch(fetchMessageRequest)) as? [Book]
                for book in books! {
                    if book.bookID == bookID {
                        return book
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        return nil
    }
    
    
    func updateBookGoogleInfo(book: Book, google_id: String, title: String, author: String, publisher: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            book.googleID = google_id
            book.author = author
            book.title = title
            book.publisher = publisher
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func updateBookPrice(book: Book, sPrice: Double, fPrice: Double) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            book.buyerPrice = fPrice
            book.sellerPrice = sPrice
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func updateBookEdition(book: Book, edition: Int) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            book.edition = Int16(edition)
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func updateBookComment(book: Book, comment: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            book.comment = comment
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func updateBookWellness(book: Book, wellness: Int) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            book.wellness = Int16(wellness)
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func fetchBooksForMain() -> [Book] {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        var res = [Book]()
        
        if let context = delegate?.managedObjectContext {
            do {
                let fetchMessageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
                let books = try(context.fetch(fetchMessageRequest)) as? [Book]
                for book in books! {
                    if book.forMain {
                        res.append(book)
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        return res
    }
    
    func storeBook(author: String?, state: String?, bookid: String?, publisher: String?, comment: String?, edition: Int16, forMain: Bool, googldID: String?, ownerID: String?, title: String?, sPrice: Double, bPrice: Double, images: [NSData]?) {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            var book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
            
            book.wellness = Int16(state!)!
            book.bookID = bookid
            book.publisher = publisher
            book.author = author
            book.comment = comment
            book.edition = edition
            book.forMain = forMain
            book.googleID = googldID
            book.ownerID = ownerID
            book.title = title
            book.sellerPrice = sPrice
            book.buyerPrice = bPrice
            
            if images != nil {
                var i = 0
                for image in images! {
                    let photo = NSEntityDescription.insertNewObject(forEntityName: "BookPhoto", into: context) as! BookPhoto
                    photo.photo = image
                    photo.book = book
                    photo.nth = Int16(i)
                    i = i + 1
                }
            }
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    func resetPhotos(book: Book, images: [UIImage]) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookPhoto")
                let objects = try(context.fetch(fetchRequest)) as? [BookPhoto]
                for object in objects! {
                    if object.book == book {
                        context.delete(object)
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
            
            do {
                var i = 0
                for image in images {
                    let photo = NSEntityDescription.insertNewObject(forEntityName: "BookPhoto", into: context) as! BookPhoto
                    photo.photo = UIImageJPEGRepresentation(image, 0.6) as NSData?
                    photo.book = book
                    photo.nth = Int16(i)
                    i = i + 1
                }
            }
            
        }
    }

}
