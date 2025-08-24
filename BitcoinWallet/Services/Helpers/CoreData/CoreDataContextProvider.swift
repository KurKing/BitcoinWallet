//
//  CoreDataContextProvider.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation
import CoreData

/// @mockable
protocol CoreDataContextProvider {
    var backgroundContext: NSManagedObjectContext { get async }
}

final class DefaultCoreDataContextProvider: CoreDataContextProvider {
    
    private var coreDataStackInternal: CoreDataStack?
    
    var backgroundContext: NSManagedObjectContext {
        get async { await coreDataStack.backgroundContext }
    }
    
    private var coreDataStack: CoreDataStack {
        
        get async {
            
            if let coreDataStackInternal {
                return coreDataStackInternal
            }
            
            let stack: CoreDataStack = await .build()
            coreDataStackInternal = stack
            
            return stack
        }
    }
}
