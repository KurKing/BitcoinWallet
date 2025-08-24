//
//  AddTransactionButtonsViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

protocol AddTransactionButtonsViewModel: AddTransactionViewModel {
    
    func addMocks()
}

class DefaultAddTransactionButtonsViewModel: DefaultAddTransactionViewModel,
                                             AddTransactionButtonsViewModel {
    
    func addMocks() {
        
        for _ in (0...100) {
            
            Task { [weak self] in
                
                let mock = TransactionDataModel.mock
                
                try? await self?.model.addTransaction(with: mock.name,
                                                      categotyName: mock.categoryName,
                                                      amount: mock.amount,
                                                      date: mock.date)
            }
        }
    }
}
