//
//  CardInfohelper.swift
//  Bocer
//
//  Created by Dempsy on 3/15/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CardInfoHelper {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let entityNames = ["Card"]
                
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
            
            let card1 = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context) as! Card
            card1.number = "4400666238381872"
            card1.month = 5
            card1.year = 19
            card1.cvv = 123
            
            let card2 = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context) as! Card
            card2.number = "6011004314531234"
            card2.month = 2
            card2.year = 22
            card2.cvv = 123
            
            let card3 = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context) as! Card
            card3.number = "4400666238381873"
            card3.month = 5
            card3.year = 19
            card3.cvv = 123
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
        
    }

    func loadData() -> [Card]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        var res = [Card]()
        
        if let context = delegate?.managedObjectContext {
            do {
                let fetchMessageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
                fetchMessageRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
                let cards = try(context.fetch(fetchMessageRequest)) as? [Card]
                res = cards!
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        return res
    }
    
    func deleteCard(card: Card) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.managedObjectContext {
            do {
                context.delete(card)
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func addCard(number: String, month: String, year: String, cvv: String) -> Card {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.managedObjectContext {
            do {
                let card = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context) as! Card
                card.cvv = Int64(cvv)!
                card.month = Int64(month)!
                card.year = Int64(year)!
                card.number = number
                try(context.save())
                return card
            } catch let err {
                print(err)
            }
        }
        return Card()
    }
}
