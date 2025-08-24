//
//  TransactionRepoAnalyticsDecoratorTests.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine
import Testing
@testable import BitcoinWallet

@Suite("TransactionRepoAnalyticsDecorator Tests", .serialized)
struct TransactionRepoAnalyticsDecoratorTests {

    // Helper to make a simple transaction (adjust if your model differs)
    private func makeTx(
        amount: Decimal = 1.23,
        category: String = "Food",
        name: String = "Coffee",
        date: Date = .now
    ) -> TransactionDataModel {
        .init(amount: amount, categoryName: category, date: date, name: name)
    }

    @Test("forwards changes output from inner repo")
    func forwards_changes() async {
        // Arrange
        let _di = MockDIContainer(type: AnalyticsService.self, service: AnalyticsServiceMock())
        let repoMock = TransactionRepoMock()
        let sut = TransactionRepoAnalyticsDecorator(repo: repoMock)

        var received = [String]()
        let c = sut.changes.sink { update in
            received.append("\(update)")
        }

        // Act
        let tx1 = makeTx(name: "A")
        let tx2 = makeTx(name: "B")
        repoMock.changesSubject.send(.added(tx1))
        repoMock.changesSubject.send(.added(tx2))
        try? await Task.sleep(for: .milliseconds(30))

        // Assert
        #expect(received.count == 2)
        #expect(received[0].contains("added"))
        #expect(received[1].contains("added"))
        _ = c
        _ = sut
    }

    @Test("tracks analytics on every change")
    func tracks_onEveryChange() async {
        // Arrange
        let analyticsMock = AnalyticsServiceMock()
        let _di = MockDIContainer(type: AnalyticsService.self, service: analyticsMock)
        let repoMock = TransactionRepoMock()
        let sut = TransactionRepoAnalyticsDecorator(repo: repoMock)

        // Act
        repoMock.changesSubject.send(.added(makeTx(amount: 0.1)))
        repoMock.changesSubject.send(.added(makeTx(amount: 0.2)))
        repoMock.changesSubject.send(.added(makeTx(amount: 0.3)))
        try? await Task.sleep(for: .milliseconds(30))

        // Assert
        #expect(analyticsMock.trackCallCount == 3)
        #expect(analyticsMock.trackArgValues.allSatisfy { $0.event == .transactionCompleted })
        let params = analyticsMock.trackArgValues.map(\.parameters)
        #expect(params.allSatisfy { $0["transaction"]?.isEmpty == false })
        _ = sut
    }

    @Test("delegates add(_:) to inner repo")
    func delegates_add() async throws {
        // Arrange
        let _di = MockDIContainer(type: AnalyticsService.self, service: AnalyticsServiceMock())
        let repoMock = TransactionRepoMock()
        let sut = TransactionRepoAnalyticsDecorator(repo: repoMock)
        let tx = makeTx(amount: 9.99, category: "Taxi", name: "Airport")

        // Act
        try await sut.add(tx)

        // Assert
        #expect(repoMock.addCallCount == 1)
        #expect(repoMock.addArgValues.count == 1)
        #expect(repoMock.addArgValues.first?.name == "Airport")
        _ = sut
    }

    @Test("delegates get(offset:limit:) to inner repo and returns result")
    func delegates_get() async throws {
        // Arrange
        let _di = MockDIContainer(type: AnalyticsService.self, service: AnalyticsServiceMock())
        let repoMock = TransactionRepoMock()
        // Stub result
        let expected = [makeTx(name: "A"), makeTx(name: "B")]
        repoMock.getHandler = { offset, limit in
            #expect(offset == 10)
            #expect(limit == 2)
            return expected
        }
        let sut = TransactionRepoAnalyticsDecorator(repo: repoMock)

        // Act
        let result = try await sut.get(offset: 10, limit: 2)

        // Assert
        #expect(repoMock.getCallCount == 1)
        #expect(result.count == 2)
        #expect(result[0].name == "A" && result[1].name == "B")
        _ = sut
    }

    @Test("tracks stringified TransactionRepoUpdate payload")
    func tracks_stringifiedPayload() async {
        // Arrange
        let analyticsMock = AnalyticsServiceMock()
        let _di = MockDIContainer(type: AnalyticsService.self, service: analyticsMock)
        let repoMock = TransactionRepoMock()
        let sut = TransactionRepoAnalyticsDecorator(repo: repoMock)

        // Act
        let tx = makeTx(amount: 3.50, category: "Food & Drinks", name: "Coffee at Starbucks")
        repoMock.changesSubject.send(.added(tx))
        try? await Task.sleep(for: .milliseconds(20))

        // Assert
        #expect(analyticsMock.trackCallCount == 1)
        let sent = analyticsMock.trackArgValues.first
        #expect(sent?.event == .transactionCompleted)
        #expect(sent?.parameters["transaction"]?.contains("added") == true)
        _ = sut
    }
}
