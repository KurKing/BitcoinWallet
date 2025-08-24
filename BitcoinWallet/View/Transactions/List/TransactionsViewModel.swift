//
//  TransactionsViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

/// @mockable
protocol TransactionsViewModel {
        
    var items: CurrentValueSubject<[TransactionsViewBlock], Never> { get }
    
    func onScrollToTheEnd()
}

class DefaultTransactionsViewModel: TransactionsViewModel {
    
    var items: CurrentValueSubject<[TransactionsViewBlock], Never> { model.viewBlocks }

    private let model: TransactionsModel
    private var cancellables: Set<AnyCancellable> = []
    
    private var offset = 0
    private var limit = 20

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
    
    func onScrollToTheEnd() {
        loadNextPage()
    }
    
    private func loadFirstPage() {

        offset = 0
        
        Task {
            await self.model.fetchTransactions(offset: offset, limit: limit)
        }
    }
    
    private func loadNextPage() {
        
        offset += limit
        
        Task {
            await self.model.fetchTransactions(offset: offset, limit: limit)
        }
    }
}
