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
    
    let events = AnalyticsEventsArray()
    
    func track(event: AnalyticsEvent, parameters: [String: String]) {
        
        let event = AnalyticsEventData(
            name: event.rawValue,
            parameters: parameters,
            date: .now
        )
        
        Task {
            await events.append(event)
        }
    }
}

actor AnalyticsEventsArray {
    
    private var events: [AnalyticsEventData] = []
    
    func append(_ event: AnalyticsEventData) {
        events.append(event)
    }
    
    func filtered(name: String?, from startDate: Date?, to endDate: Date?) -> [AnalyticsEventData] {
        
        events
            .filter { event in
                
                let matchesName: Bool = {
                    guard let name else { return true }
                    return event.name == name
                }()
                
                guard matchesName else { return false }
                
                let matchesFrom = startDate.map { event.date >= $0 } ?? true
                let matchesTo   = endDate.map { event.date <= $0 } ?? true
                return matchesFrom && matchesTo
            }
    }
}
