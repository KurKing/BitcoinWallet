//
//  AddTransactionViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation

/// @mockable
protocol AddTransactionViewModel {
    
    func addTransaction(with name: String,
                        categoryName: String,
                        amount: String,
                        date: Date,
                        type: TransactionsViewType) async
}

class DefaultAddTransactionViewModel: AddTransactionViewModel {
    
    let model: AddTransactionModel
    
    init(model: AddTransactionModel = DefaultAddTransactionModel()) {
        self.model = model
    }
    
    func addTransaction(with name: String,
                        categoryName: String,
                        amount: String,
                        date: Date,
                        type: TransactionsViewType) async {
        
        guard var decimalAmount = Decimal(string: amount) else {
            return
        }
        
        if type == .withdrawal {
            decimalAmount *= -1
        }
        
        try? await model.addTransaction(with: name,
                                        categotyName: categoryName,
                                        amount: decimalAmount,
                                        date: date)
    }
}
