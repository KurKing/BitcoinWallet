//
//  TransactionCoreDataRepo.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation
import CoreData
import Combine

final class TransactionCoreDataRepo: TransactionRepo {
    
    var changes: AnyPublisher<Void, Never> { subject.eraseToAnyPublisher() }
    private let subject = PassthroughSubject<Void, Never>()

    private var coreDataStackInternal: CoreDataStack?

    func add(_ transaction: TransactionDataModel) async throws {
        
        let context = await context
        
        try await context.perform {
            
            let entity = TransactionModel(context: context)
            
            entity.name = transaction.name
            entity.categoryName = transaction.categoryName
            entity.date = transaction.date
            entity.amount = NSDecimalNumber(decimal: transaction.amount)
            
            if context.hasChanges {
                try context.save()
            }
        }
        
        subject.send(())
    }
    
    func get(offset: Int, limit: Int) async throws -> [TransactionDataModel] {
        
        let context = await context
        
        return try await context.perform {
            
            let request = NSFetchRequest<TransactionModel>(entityName: "TransactionModel")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            request.fetchOffset = offset
            request.fetchLimit = limit
            
            let objects = try context.fetch(request)
            
            return objects.map {
                
                TransactionDataModel(
                    amount: ($0.amount)?.decimalValue ?? 0,
                    categoryName: $0.categoryName ?? "",
                    date: $0.date ?? Date(),
                    name: $0.name ?? ""
                )
            }
        }
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
    
    private var context: NSManagedObjectContext {
        get async { await coreDataStack.backgroundContext }
    }
}
