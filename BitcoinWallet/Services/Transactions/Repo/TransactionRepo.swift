//
//  TransactionRepo.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation
import Combine

protocol TransactionRepo {
    
    var changes: AnyPublisher<TransactionRepoUpdate, Never> { get }
    
    func add(_ transaction: TransactionDataModel) async throws
    
    func get(offset: Int, limit: Int)  async throws -> [TransactionDataModel]
}

enum TransactionRepoUpdate {
    case added(TransactionDataModel)
}
