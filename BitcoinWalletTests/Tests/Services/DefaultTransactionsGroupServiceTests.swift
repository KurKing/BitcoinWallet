//
//  DefaultTransactionsGroupServiceTests.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Testing
@testable import BitcoinWallet

@Suite("DefaultTransactionsGroupService Tests", .serialized)
struct DefaultTransactionsGroupServiceTests {

    // Fixed base date for deterministic grouping/sorting
    private let base = Date(timeIntervalSince1970: 1_700_000_000) // ~2023-11-14

    private func tx(name: String, hoursFromBase: TimeInterval, amount: Decimal = 1, category: String = "General") -> TransactionDataModel {
        .init(
            amount: amount,
            categoryName: category,
            date: base.addingTimeInterval(hoursFromBase * 3600),
            name: name
        )
    }

    @Test("returns empty for empty input")
    func returnsEmptyForEmptyInput() {
        // Arrange
        let sut = DefaultTransactionsGroupService()
        // Act
        let result = sut.map(models: [])
        // Assert
        #expect(result.isEmpty)
    }

    @Test("single day: groups into one section and sorts items by time desc")
    func singleDay_groupsAndSortsItemsDesc() {
        // Arrange
        let sut = DefaultTransactionsGroupService()
        // Same calendar day; times out of order
        let m1 = tx(name: "09:00", hoursFromBase: 9)
        let m2 = tx(name: "21:00", hoursFromBase: 21)
        let m3 = tx(name: "10:00", hoursFromBase: 10)

        // Act
        let result = sut.map(models: [m1, m2, m3])

        // Assert
        #expect(result.count == 1)
        let section = result[0]
        // Items sorted by date desc → 21:00, 10:00, 09:00
        #expect(section.items.map(\.name) == ["21:00", "10:00", "09:00"])

        // Section date is the start of that day
        let startOfDay = Calendar.current.startOfDay(for: m1.date)
        #expect(section.date == startOfDay)
    }

    @Test("multiple days: sections sorted by day desc; items inside each by time desc")
    func multipleDays_groupsSortsSectionsAndItems() {
        // Arrange
        let sut = DefaultTransactionsGroupService()

        // Day 1 (older)
        let d1a = tx(name: "D1-08:00", hoursFromBase: 8)
        let d1b = tx(name: "D1-22:00", hoursFromBase: 22)

        // Day 2 (newer) → +24h from base day
        let d2a = tx(name: "D2-07:00", hoursFromBase: 24 + 7)
        let d2b = tx(name: "D2-23:00", hoursFromBase: 24 + 23)

        // Mixed order input
        let input = [d2a, d1b, d2b, d1a]

        // Act
        let result = sut.map(models: input)

        // Assert
        #expect(result.count == 2)

        let cal = Calendar.current
        let day2Start = cal.startOfDay(for: d2a.date)
        let day1Start = cal.startOfDay(for: d1a.date)

        // Sections are sorted by day DESC → [Day2, Day1]
        #expect(result[0].date == day2Start)
        #expect(result[1].date == day1Start)

        // Items inside each section sorted by time DESC
        #expect(result[0].items.map(\.name) == ["D2-23:00", "D2-07:00"])
        #expect(result[1].items.map(\.name) == ["D1-22:00", "D1-08:00"])
    }

    @Test("items on boundary minutes still group by calendar startOfDay")
    func boundaryTimes_groupByStartOfDay() {
        // Arrange
        let sut = DefaultTransactionsGroupService()
        let cal = Calendar.current

        // Take a deterministic "today" 03:00 and 23:59 same day
        let dayStart = cal.startOfDay(for: base)
        let t1 = TransactionDataModel(amount: 1, categoryName: "A", date: dayStart.addingTimeInterval(3 * 3600), name: "03:00")
        let t2 = TransactionDataModel(amount: 2, categoryName: "B", date: dayStart.addingTimeInterval(23 * 3600 + 59 * 60), name: "23:59")

        // Act
        let result = sut.map(models: [t1, t2])

        // Assert
        #expect(result.count == 1)
        #expect(result[0].date == dayStart)
        #expect(result[0].items.map(\.name) == ["23:59", "03:00"])
    }
}
