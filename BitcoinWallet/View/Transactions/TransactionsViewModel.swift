//
//  TransactionsViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

protocol TransactionsViewModel {
        
    var items: CurrentValueSubject<[TransactionsViewBlock], Never> { get }
    
    func onScrollToTheEnd()
}

class DefaultTransactionsViewModel: TransactionsViewModel {
    
    var items: CurrentValueSubject<[TransactionsViewBlock], Never> { model.viewBlocks }

    private let model: TransactionsModel
    private var cancellables: Set<AnyCancellable> = []

    init(model: TransactionsModel = DefaultTransactionModel()) {
        
        self.model = model
        
        model.reloadEvent
            .throttle(for: .seconds(1), scheduler: DispatchQueue.global(), latest: true)
            .sink { [weak self] _ in
                self?.loadFirstPage()
            }
            .store(in: &cancellables)
        
        loadFirstPage()
    }
    
    func onScrollToTheEnd() {  }
    
    private func loadFirstPage() {
        
        Task {
            await self.model.fetchTransactions(offset: 0, limit: 100)
        }
    }
}
