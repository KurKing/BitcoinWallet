//
//  TransactionRepoAnalyticsDecorator.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

class TransactionRepoAnalyticsDecorator: TransactionRepo {

    var changes: AnyPublisher<TransactionRepoUpdate, Never> { repo.changes }

    @Dependency private var analyticsService: AnalyticsService
    private let repo: TransactionRepo
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(repo: TransactionRepo) {
        
        self.repo = repo
        
        changes.sink { [weak self] transaction in
            
            self?.analyticsService.track(event: .transactionCompleted,
                                         parameters: ["transaction": "\(transaction)"])
        }
        .store(in: &cancellables)
    }
    
    func add(_ transaction: TransactionDataModel) async throws {
        try await repo.add(transaction)
    }
    
    func get(offset: Int, limit: Int) async throws -> [TransactionDataModel] {
        try await repo.get(offset: offset, limit: limit)
    }
}
