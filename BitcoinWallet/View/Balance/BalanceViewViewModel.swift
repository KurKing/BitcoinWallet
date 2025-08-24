//
//  BalanceViewViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

protocol BalanceViewViewModel {
    var balance: AnyPublisher<String, Never> { get }
}

class DefaultBalanceViewViewModel: BalanceViewViewModel {
    
    private let model: BalanceViewModel
    
    init(model: BalanceViewModel = DefaultBalanceViewModel()) {
        self.model = model
    }
    
    var balance: AnyPublisher<String, Never> {
        
        model.balance
            .map { balance in
                
                let doubleValue = (balance as NSDecimalNumber).doubleValue
                return String(format: "%.5f BTC", doubleValue)
            }
            .eraseToAnyPublisher()
    }
}
