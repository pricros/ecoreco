//
//  DeviceTripDC.swift
//  Sample
//
//  Created by TSAO EVA on 2016/11/4.
//  Copyright © 2016年 TSAO EVA. All rights reserved.
//

import Foundation
import CoreData

class DeviceTripDC: BaseDataController {
    
    
    public func save(deviceId: String!, tripDistance: NSNumber?, tripTime: NSNumber?) {
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        do{
            let entity = NSEntityDescription.insertNewObject(forEntityName: "DeviceTrip", into: super.managedObjectContext!) as! DeviceTrip
                entity.deviceId = deviceId
                entity.tripDistance = tripDistance
                entity.tripTime = tripTime
            try super.managedObjectContext!.save()
        }catch {
            fatalError("Failed to save data: \(error)")
        }
        
    }
    
    
    public func show() {
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceTrip")
        do {
            let results = try super.managedObjectContext!.fetch(request) as! [DeviceTrip]
            for result in results {
                print("* deviceId: \(result.deviceId!), tripDistance: \(result.tripDistance), tripTime: \(result.tripTime)")
            }
        }catch{
            fatalError("Failed to show data: \(error)")
        }
        
    }
    
    
    public func update(deviceId: String!, tripDistance: NSNumber?, tripTime: NSNumber?){
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceTrip")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [DeviceTrip]
            if (results.count > 0){
                let entity = results[0]
                entity.tripDistance = tripDistance
                entity.tripTime = tripTime
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
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceTrip")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [DeviceTrip]
            if (results.count > 0){
                super.managedObjectContext!.delete(results[results.count-1])
                try super.managedObjectContext!.save()
            }
        } catch {
            fatalError("Failed to delete data: \(error)")
        }
        
    }
    
    
    public func find(deviceId: String!) -> DeviceTrip?{
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceTrip")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [DeviceTrip]
            if (results.count > 0){
                return results[0]
            }
        } catch {
            fatalError("Failed to find data: \(error)")
        }
        return nil
        
    }
    

}
