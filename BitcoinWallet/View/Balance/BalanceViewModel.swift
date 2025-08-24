//
//  BalanceViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

/// @mockable
protocol BalanceViewModel {
    var balance: AnyPublisher<Decimal, Never> { get }
}

class DefaultBalanceViewModel: BalanceViewModel {
    
    @Dependency private var balanceService: BalanceService

    var balance: AnyPublisher<Decimal, Never> {
        balanceService.balance
    }
}
