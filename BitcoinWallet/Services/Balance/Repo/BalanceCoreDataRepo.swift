//
//  BalanceCoreDataRepo.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation
import CoreData

class BalanceCoreDataRepo: BalanceRepo {
    
    @Dependency private var contextProvider: CoreDataContextProvider

    var balance: BalanceDataModel {
        
        get async {
            (try? await fetchBalance()) ?? 0.0
        }
    }
    
    func setBalance(_ balance: BalanceDataModel) async throws {
        
        let context = await contextProvider.backgroundContext

        return try await context.perform {
            
            let request = NSFetchRequest<CurrentBalanceModel>(entityName: "CurrentBalanceModel")
            request.fetchLimit = 1

            if let existing = try context.fetch(request).first {
                existing.deposit = NSDecimalNumber(decimal: balance)
            } else {
                
                let entity = CurrentBalanceModel(context: context)
                entity.deposit = NSDecimalNumber(decimal: balance)
            }
            
            if context.hasChanges {
                try context.save()
            }
        }
    }
    
    private func fetchBalance() async throws -> BalanceDataModel {
        
        let context = await contextProvider.backgroundContext

        return try await context.perform {
        
            let request = NSFetchRequest<CurrentBalanceModel>(entityName: "CurrentBalanceModel")
            request.fetchLimit = 1

            let rows = try context.fetch(request)
            
            return rows.first?.deposit?.decimalValue ?? 0
        }
    }
}
