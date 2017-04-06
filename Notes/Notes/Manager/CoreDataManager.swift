//
//  CoreDataManager.swift
//  Notes
//
//  Created by Lakshmi on 4/6/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import CoreData


final class CoreDataManager{
    let modelName:String
    
   
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        // Configure Managed Object Context
//        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
//    
//    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
//        // Initialize Managed Object Context
//        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        
//        // Configure Managed Object Context
//        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
//        
//        return managedObjectContext
//    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // Fetch Model URL
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        // Initialize Managed Object Model
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // Helpers
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        // URL Documents Directory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // URL Persistent Store
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            // Add Persistent Store
//            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
            
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    // MARK: - Initialization
    
    init(modelName: String) {
        self.modelName = modelName
        
        setupNotificationHandling()
    }
    
    // MARK: - Notification Handling
    
    @objc func saveChanges(_ notification: Notification) {
        saveChanges()
    }

    
    private func saveChanges(){
        guard managedObjectContext.hasChanges else{return}
        do{
            try managedObjectContext.save()
        }catch{
            
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: Notification.Name.UIApplicationWillTerminate, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }

    
}
