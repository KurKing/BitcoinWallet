//
//  TransactionsViewBlock.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation

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
}

enum TransactionsViewType {
    
    case deposit
    case withdrawal
    
    static func type(from amount: Decimal) -> TransactionsViewType {
        
        if amount >= 0 {
            .deposit
        } else {
            .withdrawal
        }
    }
}
