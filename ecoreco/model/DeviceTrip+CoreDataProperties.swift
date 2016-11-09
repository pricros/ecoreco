//
//  DeviceTrip+CoreDataProperties.swift
//  ecoreco
//
//  Created by TSAO EVA on 2016/11/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
import CoreData


extension DeviceTrip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeviceTrip> {
        return NSFetchRequest<DeviceTrip>(entityName: "DeviceTrip");
    }

    @NSManaged public var deviceId: String?
    @NSManaged public var tripDistance: NSNumber?
    @NSManaged public var tripTime: NSNumber?

}
