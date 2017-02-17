//
//  UserInfoHelper.swift
//  Bocer
//
//  Created by Dempsy on 2/16/17.
//  Copyright © 2017 Bocer. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class UserInfoHelper {
    internal func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let entityNames = ["UserInfo"]
                
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
            
            let donald = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context) as! UserInfo
            
            donald.firstname = "Donald"
            donald.lastname = "Trump"
            donald.email = "Donald.Trump@vanderbilt.edu"
            donald.id = "someid"
            donald.college = "Vanderbilt University"
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func loadData() -> UserInfo {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        var info: UserInfo?
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
                    
                let objects = try(context.fetch(fetchRequest)) as? [UserInfo]
                    
                for object in objects! {
                        info = object
                }
            } catch let err {
                print(err)
            }
        }
        return info!
    }
    
    func storeImage(image: UIImage) {
        let mImage = image.fixOrientation()
        let size = mImage.size.width < mImage.size.height ? mImage.size.width : mImage.size.height
        let x = (mImage.size.width - size) / 2.0;
        let y = (mImage.size.height - size) / 2.0;
        let cropRect = CGRect(x: x, y: y, width: size, height: size)
        let imageRef = mImage.cgImage!.cropping(to: cropRect)
        let croppedImage = UIImage(cgImage: imageRef!)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        var info: UserInfo?
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
                
                let objects = try(context.fetch(fetchRequest)) as? [UserInfo]
                
                for object in objects! {
                    info = object
                }
            } catch let err {
                print(err)
            }
            
            info?.avatar = UIImageJPEGRepresentation(croppedImage, 0.25)! as NSData?
            info?.full_avatar = UIImageJPEGRepresentation(croppedImage, 1)! as NSData?
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func saveFirstName(name: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        var info: UserInfo?
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
                
                let objects = try(context.fetch(fetchRequest)) as? [UserInfo]
                
                for object in objects! {
                    info = object
                }
            } catch let err {
                print(err)
            }
            
            info?.firstname = name
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }

    func saveLastName(name: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        var info: UserInfo?
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
                
                let objects = try(context.fetch(fetchRequest)) as? [UserInfo]
                
                for object in objects! {
                    info = object
                }
            } catch let err {
                print(err)
            }
            
            info?.lastname = name
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func saveAddress(name: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        var info: UserInfo?
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
                
                let objects = try(context.fetch(fetchRequest)) as? [UserInfo]
                
                for object in objects! {
                    info = object
                }
            } catch let err {
                print(err)
            }
            
            info?.address = name
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func saveCollege(name: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        var info: UserInfo?
        
        if let context = delegate?.managedObjectContext {
            
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
                
                let objects = try(context.fetch(fetchRequest)) as? [UserInfo]
                
                for object in objects! {
                    info = object
                }
            } catch let err {
                print(err)
            }
            
            info?.college = name
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
}
