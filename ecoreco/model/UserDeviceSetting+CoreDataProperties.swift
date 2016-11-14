//
//  UserDeviceSetting+CoreDataProperties.swift
//  ecoreco
//
//  Created by TSAO EVA on 2016/11/4.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
import CoreData


extension UserDeviceSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDeviceSetting> {
        return NSFetchRequest<UserDeviceSetting>(entityName: "UserDeviceSetting");
    }

    @NSManaged public var deviceId: String?
    @NSManaged public var email: String?
    @NSManaged public var emergencycall: String?
    @NSManaged public var emergencysms: String?
    @NSManaged public var sound: Bool
    @NSManaged public var speedLimit: NSNumber?
    @NSManaged public var vibrate: Bool

}
