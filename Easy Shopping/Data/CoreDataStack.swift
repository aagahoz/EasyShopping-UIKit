//
//  CoreDataStack.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 21.12.2025.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Easy_Shopping")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData load error \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = context
        guard context.hasChanges else { return }
        try? context.save()
    }
}
