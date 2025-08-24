//
//  TransactionsModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

protocol TransactionsModel {
    
    var reloadEvent: AnyPublisher<Void, Never> { get }
    var viewBlocks: CurrentValueSubject<[TransactionsViewBlock], Never> { get }
    
    func fetchTransactions(offset: Int, limit: Int) async
}

class DefaultTransactionModel: TransactionsModel {
    
    let viewBlocks = CurrentValueSubject<[TransactionsViewBlock], Never>([])
    
    var reloadEvent: AnyPublisher<Void, Never> {
        repo.changes.map { _ in }.eraseToAnyPublisher()
    }
    
    @Dependency private var repo: TransactionRepo
    @Dependency private var groupService: TransactionsGroupService
    
    private var transactions = [TransactionDataModel]()
    
    private let dayDateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let viewBlockDateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
    
    func fetchTransactions(offset: Int, limit: Int) async {
        
        if offset == 0 {
            transactions = []
        }
        
        guard let items = try? await repo.get(offset: offset, limit: limit),
              !items.isEmpty else {
            
            if offset == 0 {
                viewBlocks.send([])
            }
            return
        }
        
        transactions.append(contentsOf: items)
        
        let groups = groupService.map(models: transactions)
        
        let viewBlocks: [TransactionsViewBlock] = groups.map { daySection in
            
            let items = daySection.items.map({ $0.toViewItem(with: viewBlockDateFormatter) })
            
            return .init(transactions: items,
                         day: daySection.date.map(with: dayDateFormatter))
        }
        
        self.viewBlocks.send(viewBlocks)
    }
}

private extension Date {
    
    func map(with dateFormatter: DateFormatter) -> String {
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) { return "Today"}
        if calendar.isDateInYesterday(self) { return "Yesterday" }
        
        return dateFormatter.string(from: self)
    }
}

private extension TransactionDataModel {
    
    func toViewItem(with dateFormatter: DateFormatter) -> TransactionsViewItem {
        
        let amountPrefix = amount >= 0 ? "+" : ""
        
        return .init(amount: amountPrefix + "\(amount) BTC",
                     categoryName: categoryName,
                     date: dateFormatter.string(from: date),
                     name: name,
                     type: .type(from: amount))
    }
}
