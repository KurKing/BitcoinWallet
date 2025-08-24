//
//  TransactionDataModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation

struct TransactionDataModel: Equatable {
    
    let amount: Decimal
    let categoryName: String
    let date: Date
    let name: String
}

extension TransactionDataModel {
    
    static var mockTransactions: [TransactionDataModel] {
        
        let cal = Calendar.current
        
        return [
            TransactionDataModel(
                amount: Decimal(
                    string: "3.50"
                )!,
                categoryName: "Food & Drinks",
                date: 
                        .randomInLast(
                            days: 30,
                            calendar: cal
                        ),
                name: "Coffee at Starbucks"
            ),
            TransactionDataModel(
                amount: Decimal(
                    string: "25.00"
                )!,
                categoryName: "Transport",
                date: .randomInLast(
                    days: 30,
                    calendar: cal
                ),
                name: "Taxi ride"
            ),
            TransactionDataModel(
                amount: Decimal(
                    string: "120.90"
                )!,
                categoryName: "Shopping",
                date: .randomInLast(
                    days: 30,
                    calendar: cal
                ),
                name: "New Sneakers"
            ),
            TransactionDataModel(
                amount: Decimal(
                    string: "59.90"
                )!,
                categoryName: "Groceries",
                date: .randomInLast(
                    days: 30,
                    calendar: cal
                ),
                name: "Supermarket"
            ),
            TransactionDataModel(
                amount: Decimal(
                    string: "14.99"
                )!,
                categoryName: "Subscriptions",
                date: .randomInLast(
                    days: 30,
                    calendar: cal
                ),
                name: "Netflix"
            ),
            TransactionDataModel(
                amount: Decimal(
                    string: "200.00"
                )!,
                categoryName: "Bills",
                date: .randomInLast(
                    days: 30,
                    calendar: cal
                ),
                name: "Electricity"
            ),
            TransactionDataModel(
                amount: Decimal(
                    string: "15.75"
                )!,
                categoryName: "Food & Drinks",
                date: .randomInLast(
                    days: 30,
                    calendar: cal
                ),
                name: "Lunch at Cafe"
            ),
            TransactionDataModel(
                amount: Decimal(
                    string: "75.00"
                )!,
                categoryName: "Entertainment",
                date: .randomInLast(
                    days: 30,
                    calendar: cal
                ),
                name: "Concert Ticket"
            ),
            TransactionDataModel(
                amount: Decimal(
                    string: "9.99"
                )!,
                categoryName: "Subscriptions",
                date: .randomInLast(
                    days: 30,
                    calendar: cal
                ),
                name: "Spotify"
            ),
            TransactionDataModel(
                amount: Decimal(
                    string: "350.00"
                )!,
                categoryName: "Travel",
                date: .randomInLast(
                    days: 30,
                    calendar: cal
                ),
                name: "Weekend Trip"
            )
        ]
    }
}

extension Date {
    
    static func randomInLast(days: Int, calendar: Calendar = .current) -> Date {
        
        let now = Date()
        
        let dayOffset = Int.random(in: 0...days)
        let startOfRandomDay = calendar.startOfDay(for: calendar.date(byAdding: .day,
                                                                      value: -dayOffset,
                                                                      to: now)!)
        let secondsInDay = 24 * 60 * 60
        let randomSecond = Int.random(in: 0..<secondsInDay)
        
        return calendar.date(byAdding: .second, value: randomSecond, to: startOfRandomDay)!
    }
}
