//
//  BaseDataController.swift
//  Sample
//
//  Created by TSAO EVA on 2016/11/4.
//  Copyright © 2016年 TSAO EVA. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BaseDataController: NSObject {
    
    public var managedObjectContext: NSManagedObjectContext?
    
    public func prepareManagedObjectContext(){
        
        if #available(iOS 10.0, *) {
        
            self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
        } else {
            // iOS 9.0 and below - however you were previously handling it
            guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
                fatalError("Error loading model from bundle")
            }
            guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Error initializing mom from: \(modelURL)")
            }
            let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
            self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            let storeURL = docURL.appendingPathComponent("Model.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
            
        }
    }
    
    
}
