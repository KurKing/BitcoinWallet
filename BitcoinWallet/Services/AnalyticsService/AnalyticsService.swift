//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation

protocol AnalyticsService {
    func track(event: AnalyticsEvent, parameters: [String: String])
}

class DefaultAnalyticsService: AnalyticsService {
    
    private var events: [AnalyticsEventData] = []
    
    func track(event: AnalyticsEvent, parameters: [String: String]) {
        
        let event = AnalyticsEventData(
            name: event.rawValue,
            parameters: parameters,
            date: .now
        )
        
        events.append(event)
    }
}
