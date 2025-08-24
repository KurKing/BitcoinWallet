//
//  TransactionsGroupService.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation

/// @mockable
protocol TransactionsGroupService {
    func map(models: [TransactionDataModel]) -> [TransactionDaySection]
}

class DefaultTransactionsGroupService: TransactionsGroupService {
    
    func map(models: [TransactionDataModel]) -> [TransactionDaySection] {
        
        guard !models.isEmpty else { return [] }
        
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: models) {
            calendar.startOfDay(for: $0.date)
        }

        let sortedDays = grouped.keys.sorted(by: >)

        return sortedDays.map { dayStart in
            
            let items = (grouped[dayStart] ?? []).sorted { $0.date > $1.date }
            
            return TransactionDaySection(date: dayStart, items: items)
        }
    }
}

struct TransactionDaySection: Equatable {
    
    let date: Date
    let items: [TransactionDataModel]
}
