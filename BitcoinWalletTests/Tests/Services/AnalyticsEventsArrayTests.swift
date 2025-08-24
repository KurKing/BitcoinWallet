//
//  AnalyticsEventsArrayTests.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Testing
@testable import BitcoinWallet

@Suite("AnalyticsEventsArray Tests", .serialized)
struct AnalyticsEventsArrayTests {

    // Deterministic base time for reproducibility
    private let base = Date(timeIntervalSince1970: 1_700_000_000)

    private func makeEvent(_ name: AnalyticsEvent, offset: TimeInterval) -> AnalyticsEventData {
        .init(name: name.rawValue, parameters: [:], date: base.addingTimeInterval(offset))
    }

    @Test("Returns all events with no filters")
    func noFiltersReturnsAll() async {
        // Arrange
        let sut = AnalyticsEventsArray()
        let e1 = makeEvent(.btcRateUpdated,        offset:   0)
        let e2 = makeEvent(.transactionIntention,  offset: 100)
        let e3 = makeEvent(.transactionCompleted,  offset: 200)
        await sut.append(e1); await sut.append(e2); await sut.append(e3)

        // Act
        let result = await sut.filtered(name: nil, from: nil, to: nil)

        // Assert
        #expect(result.count == 3)
        #expect(result.map(\.name) == [e1.name, e2.name, e3.name])
    }

    @Test("Filters by name only")
    func filtersByNameOnly() async {
        // Arrange
        let sut = AnalyticsEventsArray()
        let e1 = makeEvent(.btcRateUpdated,       offset: 0)
        let e2 = makeEvent(.transactionIntention, offset: 1)
        await sut.append(e1); await sut.append(e2)

        // Act
        let result = await sut.filtered(
            name: AnalyticsEvent.transactionIntention.rawValue,
            from: nil,
            to: nil
        )

        // Assert
        #expect(result.count == 1)
        #expect(result.first?.name == AnalyticsEvent.transactionIntention.rawValue)
    }

    @Test("Filters by date range [inclusive]")
    func filtersByDateRangeInclusive() async {
        // Arrange
        let sut = AnalyticsEventsArray()
        let early   = makeEvent(.btcRateUpdated,       offset:   0)   // < start
        let startEv = makeEvent(.transactionIntention, offset: 100)   // == start
        let mid     = makeEvent(.btcRateUpdated,       offset: 150)   // between
        let endEv   = makeEvent(.transactionCompleted, offset: 200)   // == end
        let late    = makeEvent(.transactionCompleted, offset: 250)   // > end
        for e in [early, startEv, mid, endEv, late] { await sut.append(e) }
        let start = base.addingTimeInterval(100)
        let end   = base.addingTimeInterval(200)

        // Act
        let result = await sut.filtered(name: nil, from: start, to: end)

        // Assert
        #expect(result.map(\.name) == [startEv.name, mid.name, endEv.name])
        #expect(result.allSatisfy { $0.date >= start && $0.date <= end })
    }

    @Test("Filters by name AND date range")
    func filtersByNameAndDateRange() async {
        // Arrange
        let sut = AnalyticsEventsArray()
        let inNameOutOfRange  = makeEvent(.transactionCompleted, offset:  50)
        let inBoth1           = makeEvent(.transactionCompleted, offset: 120)
        let inBoth2           = makeEvent(.transactionCompleted, offset: 180)
        let inRangeOtherName  = makeEvent(.btcRateUpdated,       offset: 150)
        for e in [inNameOutOfRange, inBoth1, inBoth2, inRangeOtherName] { await sut.append(e) }
        let start = base.addingTimeInterval(100)
        let end   = base.addingTimeInterval(200)

        // Act
        let result = await sut.filtered(
            name: AnalyticsEvent.transactionCompleted.rawValue,
            from: start,
            to: end
        )

        // Assert
        #expect(result.map(\.date) == [inBoth1.date, inBoth2.date])
        #expect(result.allSatisfy { $0.name == AnalyticsEvent.transactionCompleted.rawValue })
    }

    @Test("Empty storage returns empty")
    func emptyReturnsEmpty() async {
        // Arrange
        let sut = AnalyticsEventsArray()

        // Act
        let result = await sut.filtered(name: nil, from: nil, to: nil)

        // Assert
        #expect(result.isEmpty)
    }

    @Test("No matches returns empty")
    func noMatchesReturnsEmpty() async {
        // Arrange
        let sut = AnalyticsEventsArray()
        await sut.append(makeEvent(.btcRateUpdated, offset: 0))

        // Act
        let result = await sut.filtered(name: "unknown_event", from: nil, to: nil)

        // Assert
        #expect(result.isEmpty)
    }
}
