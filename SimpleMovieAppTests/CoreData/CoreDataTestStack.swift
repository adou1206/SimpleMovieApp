//
//  CoreDataTestStack.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 05/08/2024.
//

import XCTest
import CoreData
@testable import SimpleMovieApp

struct CoreDataTestStack {
        
    let persistentContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    init() {
        persistentContainer = NSPersistentContainer(name: "MovieDataModel")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
}
