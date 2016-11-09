//
//  UserProfileDC.swift
//  Sample
//
//  Created by TSAO EVA on 2016/11/4.
//  Copyright © 2016年 TSAO EVA. All rights reserved.
//

import Foundation
import CoreData

class UserProfileDC: BaseDataController {
    
    
    public func save(email: String!, birthday: NSDate?, gender: NSNumber?, unit: NSNumber?, height: NSDecimalNumber?, weight: NSDecimalNumber?) {
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        do{
            let entity = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: super.managedObjectContext!) as! UserProfile
                entity.email = email
                entity.birthday = birthday
                entity.gender = gender
                entity.unit = unit
                entity.height = height
                entity.weight = weight
            try super.managedObjectContext!.save()
        }catch {
            fatalError("Failed to save data: \(error)")
        }
        
    }
    
    
    public func show() {
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        do {
            let results = try super.managedObjectContext!.fetch(request) as! [UserProfile]
            for result in results {
                print("* email: \(result.email), birthday: \(result.birthday), gender: \(result.gender), unit: \(result.unit), height: \(result.height), weight: \(result.weight)")
            }
        }catch{
            fatalError("Failed to show data: \(error)")
        }
        
    }
    
    
    public func update(email: String!, birthday: NSDate?, gender: NSNumber?, unit: NSNumber?, height: NSDecimalNumber?, weight: NSDecimalNumber?){
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        request.predicate = NSPredicate(format: "email == %@", email)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [UserProfile]
            if (results.count > 0){
                let entity = results[0]
                entity.email = email
                entity.birthday = birthday
                entity.gender = gender
                entity.unit = unit
                entity.height = height
                entity.weight = weight
                try super.managedObjectContext!.save()
            }
        } catch {
            fatalError("Failed to update data: \(error)")
        }
        
    }
    
    
    public func delete(deviceId: String!){
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [UserProfile]
            if (results.count > 0){
                super.managedObjectContext!.delete(results[results.count-1])
                try super.managedObjectContext!.save()
            }
        } catch {
            fatalError("Failed to delete data: \(error)")
        }
        
    }
    
    
    public func find(deviceId: String!) -> UserProfile?{
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [UserProfile]
            if (results.count > 0){
                return results[0]
            }
        } catch {
            fatalError("Failed to find data: \(error)")
        }
        return nil
        
    }
    

}
