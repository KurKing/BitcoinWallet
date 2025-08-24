//
//  DefaultAnalyticsServiceTests.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Testing
@testable import BitcoinWallet // change if needed

@Suite("DefaultAnalyticsService Tests", .serialized)
struct DefaultAnalyticsServiceTests {

    @Test("track appends one event")
    func track_appendsOne() async {
        // Arrange
        let sut = DefaultAnalyticsService()
        let before = Date()

        // Act
        sut.track(event: .btcRateUpdated, parameters: ["src": "unit"])
        try? await Task.sleep(for: .milliseconds(30)) // allow async append
        let snapshot = await sut.events.filtered(name: nil, from: nil, to: nil)
        let after = Date()

        // Assert
        #expect(snapshot.count == 1)
        let e = snapshot[0]
        #expect(e.name == AnalyticsEvent.btcRateUpdated.rawValue)
        #expect(e.parameters == ["src": "unit"])
        #expect(e.date >= before && e.date <= after)
    }

    @Test("track appends multiple events in order")
    func track_appendsMultipleInOrder() async {
        // Arrange
        let sut = DefaultAnalyticsService()

        // Act
        sut.track(event: .transactionIntention, parameters: [:])
        try? await Task.sleep(for: .milliseconds(20))
        sut.track(event: .transactionCompleted, parameters: ["amount": "0.01"])
        try? await Task.sleep(for: .milliseconds(40))
        let snapshot = await sut.events.filtered(name: nil, from: nil, to: nil)

        // Assert
        #expect(snapshot.count == 2)
        #expect(snapshot.map(\.name) == [
            AnalyticsEvent.transactionIntention.rawValue,
            AnalyticsEvent.transactionCompleted.rawValue
        ])
        #expect(snapshot[1].parameters == ["amount": "0.01"])
    }

    @Test("initially empty")
    func initially_empty() async {
        // Arrange
        let sut = DefaultAnalyticsService()

        // Act
        let snapshot = await sut.events.filtered(name: nil, from: nil, to: nil)

        // Assert
        #expect(snapshot.isEmpty)
    }
}
