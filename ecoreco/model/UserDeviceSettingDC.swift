//
//  UserDeviceSettingDC.swift
//  Sample
//
//  Created by TSAO EVA on 2016/11/4.
//  Copyright © 2016年 TSAO EVA. All rights reserved.
//

import Foundation
import CoreData

class UserDeviceSettingDC: BaseDataController {
    
    
    public func save(deviceId: String!, email: String?, emergencycall: String?, emergencysms: String?, sound: Bool, speedLimit: NSNumber?, vibrate: Bool) {
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        do{
            let entity = NSEntityDescription.insertNewObject(forEntityName: "UserDeviceSetting", into: super.managedObjectContext!) as! UserDeviceSetting
            entity.deviceId = deviceId
                entity.email = email
                entity.emergencycall = emergencycall
                entity.emergencysms = emergencysms
                entity.sound = sound
                entity.speedLimit = speedLimit
                entity.vibrate = vibrate
            try super.managedObjectContext!.save()
        }catch {
            fatalError("Failed to save data: \(error)")
        }
        
    }
    
    
    public func show() {
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDeviceSetting")
        do {
            let results = try super.managedObjectContext!.fetch(request) as! [UserDeviceSetting]
            for result in results {
                print("* deviceId: \(result.deviceId!), email: \(result.email), emergencycall: \(result.emergencycall), emergencysms: \(result.emergencysms), sound: \(result.sound), speedLimit: \(result.speedLimit), vibrate: \(result.vibrate)")
            }
        }catch{
            fatalError("Failed to show data: \(error)")
        }
        
    }
    
    public func update(deviceId: String!, email: String?, emergencycall: String?, emergencysms: String?, sound: Bool, speedLimit: NSNumber?, vibrate: Bool){
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDeviceSetting")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        //request.predicate = NSPredicate(format: "id == \(id)")//integer
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [UserDeviceSetting]
            if (results.count > 0){
                let entity = results[0]
                entity.email = email
                entity.emergencycall = emergencycall
                entity.emergencysms = emergencysms
                entity.sound = sound
                entity.speedLimit = speedLimit
                entity.vibrate = vibrate
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
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDeviceSetting")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [UserDeviceSetting]
            if (results.count > 0){
                super.managedObjectContext!.delete(results[results.count-1])
                try super.managedObjectContext!.save()
            }
        } catch {
            fatalError("Failed to delete data: \(error)")
        }
        
    }
    
    
    public func find(deviceId: String!) -> UserDeviceSetting?{
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDeviceSetting")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [UserDeviceSetting]
            if (results.count > 0){
                return results[0]
            }
        } catch {
            fatalError("Failed to find data: \(error)")
        }
        return nil
        
    }
    

}
