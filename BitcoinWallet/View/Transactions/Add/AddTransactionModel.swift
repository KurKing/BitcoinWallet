//
//  AddTransactionModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation

/// @mockable
protocol AddTransactionModel {
    
    func addTransaction(with name: String,
                        categotyName: String,
                        amount: Decimal,
                        date: Date) async throws
}

class DefaultAddTransactionModel: AddTransactionModel {
    
    @Dependency private var repo: TransactionRepo
    
    func addTransaction(with name: String,
                        categotyName: String,
                        amount: Decimal,
                        date: Date) async throws {
        
        try await repo.add(.init(amount: amount,
                                 categoryName: categotyName,
                                 date: date,
                                 name: name))
    }
}
