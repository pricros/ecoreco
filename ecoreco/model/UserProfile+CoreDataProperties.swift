//
//  UserProfile+CoreDataProperties.swift
//  ecoreco
//
//  Created by TSAO EVA on 2016/11/9.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile");
    }

    @NSManaged public var birthday: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var gender: NSNumber?
    @NSManaged public var height: NSDecimalNumber?
    @NSManaged public var unit: NSNumber?
    @NSManaged public var weight: NSDecimalNumber?

}
