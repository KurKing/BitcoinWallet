//
//  AddTransactionViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation

protocol AddTransactionViewModel {
    func add(transaction: TransactionsViewItem) async
}

class DefaultAddTransactionViewModel {
    
    let model: AddTransactionModel
    
    init(model: AddTransactionModel = DefaultAddTransactionModel()) {
        self.model = model
    }
    
    func add(transaction: TransactionsViewItem) async {
        
        guard let decimalAmount = Decimal(string: transaction.amount) else {
            return
        }
        
        try? await model.addTransaction(with: transaction.name,
                                        categotyName: transaction.categoryName,
                                        amount: decimalAmount,
                                        date: Date())
    }
}
