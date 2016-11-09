//
//  DeviceInfo+CoreDataProperties.swift
//  ecoreco
//
//  Created by TSAO EVA on 2016/11/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
import CoreData


extension DeviceInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeviceInfo> {
        return NSFetchRequest<DeviceInfo>(entityName: "DeviceInfo");
    }

    @NSManaged public var batteryAmount: NSNumber?
    @NSManaged public var deviceId: String?
    @NSManaged public var deviceName: String?
    @NSManaged public var estimateRange: NSNumber?
    @NSManaged public var mode: NSNumber?
    @NSManaged public var odometer: NSNumber?

}
