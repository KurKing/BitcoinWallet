//
//  TransactionDataModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation

struct TransactionDataModel {
    
    let amount: Decimal
    let categoryName: String
    let date: Date
    let name: String
}

extension TransactionDataModel {
    
    static var mockTransactions: [TransactionDataModel] {
        [
            TransactionDataModel(
                amount: 3.50,
                categoryName: "Food & Drinks",
                date: Date().addingTimeInterval(-3600),
                name: "Coffee at Starbucks"
            ),
            TransactionDataModel(
                amount: 25.00,
                categoryName: "Transport",
                date: Date().addingTimeInterval(-86400),
                name: "Taxi ride"
            ),
            TransactionDataModel(
                amount: 120.90,
                categoryName: "Shopping",
                date: Date().addingTimeInterval(-2 * 86400),
                name: "New Sneakers"
            ),
            TransactionDataModel(
                amount: 59.90,
                categoryName: "Groceries",
                date: Date().addingTimeInterval(-3 * 86400),
                name: "Supermarket"
            ),
            TransactionDataModel(
                amount: 14.99,
                categoryName: "Subscriptions",
                date: Date().addingTimeInterval(-7 * 86400),
                name: "Netflix"
            ),
            TransactionDataModel(
                amount: 200.00,
                categoryName: "Bills",
                date: Date().addingTimeInterval(-10 * 86400),
                name: "Electricity"
            ),
            TransactionDataModel(
                amount: 15.75,
                categoryName: "Food & Drinks",
                date: Date().addingTimeInterval(-12 * 86400),
                name: "Lunch at Cafe"
            ),
            TransactionDataModel(
                amount: 75.00,
                categoryName: "Entertainment",
                date: Date().addingTimeInterval(-14 * 86400),
                name: "Concert Ticket"
            ),
            TransactionDataModel(
                amount: 9.99,
                categoryName: "Subscriptions",
                date: Date().addingTimeInterval(-20 * 86400),
                name: "Spotify"
            ),
            TransactionDataModel(
                amount: 350.00,
                categoryName: "Travel",
                date: Date().addingTimeInterval(-30 * 86400),
                name: "Weekend Trip"
            )
        ]
    }
}
