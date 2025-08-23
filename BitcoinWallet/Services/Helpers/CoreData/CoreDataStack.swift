//
//  CoreDataStack.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    var backgroundContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    private let container: NSPersistentContainer

    private init(container: NSPersistentContainer) {
        self.container = container
    }

    static func build(modelName: String = "BitcoinWallet") async -> CoreDataStack {
        
        let container = NSPersistentContainer(name: modelName)
        
        await withCheckedContinuation { continuation in
            container.loadPersistentStores { _, error in
                continuation.resume(returning: ())
            }
        }
        
        return CoreDataStack(container: container)
    }
}
