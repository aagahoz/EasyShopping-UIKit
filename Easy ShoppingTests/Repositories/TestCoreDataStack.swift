//
//  TestCoreDataStack.swift
//  Easy ShoppingTests
//
//  Created by Agah Ozdemir on 21.12.2025.
//

import CoreData

final class TestCoreDataStack {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Easy_Shopping")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Test CoreData load error: \(error)")
            }
            
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
}
