//
//  AnalyticsEvent.swift
//  TransactionsTestTask
//
//

import Foundation

struct AnalyticsEventData {
    
    let name: String
    let parameters: [String: String]
    let date: Date
}

enum AnalyticsEvent: String {
    
    case btcRateUpdated = "btc_rate_updated"
    
    case transactionIntention = "transaction_intention"
    case transactionCompleted = "transaction_completed"
}
