//
//  TransactionsViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

struct TransactionsViewBlock {
    
    let transactions: [TransactionsViewItem]
    let day: String
}

struct TransactionsViewItem {
    
    let amount: String
    let categoryName: String
    let date: String
    let name: String
    
    let type: TransactionsViewType
    
    enum TransactionsViewType {
        
        case deposit
        case withdrawal
    }
}

protocol TransactionsViewModel {
    
    var isLoading: AnyPublisher<Bool, Never> { get }
    
    var items: CurrentValueSubject<[TransactionsViewBlock], Never> { get }
    
    func onScrollToTheEnd()
}

class MockTransactionsViewModel: TransactionsViewModel {
    
    var isLoading: AnyPublisher<Bool, Never>
    var items: CurrentValueSubject<[TransactionsViewBlock], Never>
    
    init() {
        
        let mockBlocks: [TransactionsViewBlock] = [
            TransactionsViewBlock(
                transactions: [
                    TransactionsViewItem(amount: "+0.5123123123123123 BTC",
                                         categoryName: "Groceries",
                                         date: "10:45",
                                         name: "Supermarket",
                                         type: .withdrawal),
                    TransactionsViewItem(amount: "+1.2123123123123123 BTC",
                                         categoryName: "Deposit",
                                         date: "12:10",
                                         name: "Top-up",
                                         type: .deposit)
                ],
                day: "Today"
            ),
            TransactionsViewBlock(
                transactions: [
                    TransactionsViewItem(amount: "-0.3123123123123123 BTC",
                                         categoryName: "Taxi",
                                         date: "09:20",
                                         name: "Uber",
                                         type: .withdrawal)
                ],
                day: "Yesterday"
            )
        ]
        
        self.items = CurrentValueSubject<[TransactionsViewBlock], Never>(mockBlocks)
        self.isLoading = Just(false).eraseToAnyPublisher()
    }
    
    func onScrollToTheEnd() { }
}
