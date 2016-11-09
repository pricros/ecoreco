//
//  DeviceInfoDC.swift
//  Sample
//
//  Created by TSAO EVA on 2016/11/4.
//  Copyright © 2016年 TSAO EVA. All rights reserved.
//

import Foundation
import CoreData

class DeviceInfoDC: BaseDataController {
    
    
    public func save(deviceId: String!, deviceName: String?, batteryAmount: NSNumber?, estimateRange: NSNumber?, mode: NSNumber?, odometer: NSNumber?) {
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        do{
            let entity = NSEntityDescription.insertNewObject(forEntityName: "DeviceInfo", into: super.managedObjectContext!) as! DeviceInfo
                entity.deviceId = deviceId
                entity.deviceName = deviceName
                entity.batteryAmount = batteryAmount
                entity.estimateRange = estimateRange
                entity.mode = mode
                entity.odometer = odometer
            try super.managedObjectContext!.save()
        }catch {
            fatalError("Failed to save data: \(error)")
        }
        
    }
    
    
    public func show() {
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceInfo")
        do {
            let results = try super.managedObjectContext!.fetch(request) as! [DeviceInfo]
            for result in results {
                print("* deviceId: \(result.deviceId!), deviceName: \(result.deviceName), batteryAmount: \(result.batteryAmount), estimateRange: \(result.estimateRange), mode: \(result.mode), odometer: \(result.odometer)")
            }
        }catch{
            fatalError("Failed to show data: \(error)")
        }
        
    }
    
    
    public func update(deviceId: String!, deviceName: String?, batteryAmount: NSNumber?, estimateRange: NSNumber?, mode: NSNumber?, odometer: NSNumber?){
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceInfo")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [DeviceInfo]
            if (results.count > 0){
                let entity = results[0]
                entity.deviceName = deviceName
                entity.batteryAmount = batteryAmount
                entity.estimateRange = estimateRange
                entity.mode = mode
                entity.odometer = odometer
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
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceInfo")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [DeviceInfo]
            if (results.count > 0){
                super.managedObjectContext!.delete(results[results.count-1])
                try super.managedObjectContext!.save()
            }
        } catch {
            fatalError("Failed to delete data: \(error)")
        }
        
    }
    
    
    public func find(deviceId: String!) -> DeviceInfo?{
        
        if super.managedObjectContext==nil{
            prepareManagedObjectContext()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceInfo")
        request.predicate = NSPredicate(format: "deviceId == %@", deviceId)
        
        do{
            let results = try super.managedObjectContext!.fetch(request) as! [DeviceInfo]
            if (results.count > 0){
                return results[0]
            }
        } catch {
            fatalError("Failed to find data: \(error)")
        }
        return nil
        
    }
    

}
