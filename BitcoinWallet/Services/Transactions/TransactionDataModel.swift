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
    
    static var mock: TransactionDataModel {
        
        let cal = Calendar.current
        
        return .init(amount: Decimal(Double.random(in: -100000...100000)),
                     categoryName: "Category \(Int.random(in: 1...100))",
                     date: .randomInLast(
                        days: 30,
                        calendar: cal
                     ),
                     name: "Test \(Int.random(in: 1...1000))")
    }
}

private extension Date {
    
    static func randomInLast(days: Int, calendar: Calendar = .current) -> Date {
        
        let now = Date()
        
        let dayOffset = Int.random(in: 0...days)
        let startOfRandomDay = calendar.startOfDay(for: calendar.date(byAdding: .day,
                                                                      value: -dayOffset,
                                                                      to: now)!)
        let randomSecond = Int.random(in: 0..<24 * 60 * 60)
        
        return calendar.date(byAdding: .second, value: randomSecond, to: startOfRandomDay)!
    }
}
