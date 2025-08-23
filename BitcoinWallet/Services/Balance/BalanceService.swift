//
//  BalanceService.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation
import Combine

protocol BalanceService {
    var balance: AnyPublisher<Decimal, Never> { get }
}

class TransactionBasedBalanceService: BalanceService {

    var balance: AnyPublisher<Decimal, Never> {
        wallet.balancePublisher.eraseToAnyPublisher()
    }
    
    private let wallet = Wallet()
    
    @Dependency private var balanceRepo: BalanceRepo
    @Dependency private var transactionsRepo: TransactionRepo
    
    private var cancellables: Set<AnyCancellable> = []

    init() {
        
        Task {
            
            let initialBalance = await balanceRepo.balance
            await wallet.deposit(initialBalance)

            await setup()
        }
    }

    private func setup() async {
        
        transactionsRepo
            .changes
            .map { update in
                
                switch update {
                case .added(let transactionDataModel):
                    transactionDataModel.amount
                }
            }
            .sink { [weak self] transaction in
                
                Task { [weak self] in
                    await self?.wallet.deposit(transaction)
                }
            }
            .store(in: &cancellables)
        
        wallet.balancePublisher
            .removeDuplicates()
            .throttle(for: .seconds(1), scheduler: DispatchQueue.global(), latest: true)
            .sink { [weak self] balance in
                
                Task.detached { [weak self] in
                    try? await self?.balanceRepo.setBalance(balance)
                }
            }
            .store(in: &cancellables)
    }
}

fileprivate actor Wallet {
    
    private var balanceValue: Decimal
    nonisolated private let subject: CurrentValueSubject<Decimal, Never>
    
    init(initialBalance: Decimal = 0) {
        
        self.balanceValue = initialBalance
        self.subject = .init(initialBalance)
    }
    
    var balance: Decimal {
        balanceValue
    }
    
    nonisolated var balancePublisher: AnyPublisher<Decimal, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func deposit(_ amount: Decimal) {
        balanceValue += amount
        subject.send(balanceValue)
    }
}
