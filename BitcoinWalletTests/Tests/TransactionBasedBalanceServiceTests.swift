//
//  TransactionBasedBalanceServiceTests.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine
import Testing
@testable import BitcoinWallet

@Suite("TransactionBasedBalanceService Tests", .serialized)
struct TransactionBasedBalanceServiceTests {

    // MARK: - Helpers
    private func makeTx(
        amount: Decimal,
        category: String = "Food",
        name: String = "N/A",
        date: Date = .now
    ) -> TransactionDataModel {
        .init(amount: amount, categoryName: category, date: date, name: name)
    }

    // MARK: - Tests

    @Test("emits initial balance from repo")
    func emitsInitialBalance() async {
        // Arrange
        let balanceMock = BalanceRepoMock(balance: 2)
        let _di1 = MockDIContainer(type: BalanceRepo.self, service: balanceMock)

        let txRepoMock = TransactionRepoMock()
        let _di2 = MockDIContainer(type: TransactionRepo.self, service: txRepoMock)

        let sut = TransactionBasedBalanceService()
        var received: [Decimal] = []
        let c = sut.balance.sink { received.append($0) }

        // Act
        try? await Task.sleep(for: .milliseconds(40)) // allow async init Task to run

        // Assert
        #expect(received.last == 2)
        _ = c
    }

    @Test("accumulates balance from transaction changes")
    func accumulatesFromChanges() async {
        // Arrange
        let balanceMock = BalanceRepoMock(balance: 0)
        let _di1 = MockDIContainer(type: BalanceRepo.self, service: balanceMock)

        let txRepoMock = TransactionRepoMock()
        let _di2 = MockDIContainer(type: TransactionRepo.self, service: txRepoMock)

        let sut = TransactionBasedBalanceService()
        var received: [Decimal] = []
        let c = sut.balance.sink { received.append($0) }

        try? await Task.sleep(for: .milliseconds(20)) // let setup() subscribe

        // Act
        txRepoMock.changesSubject.send(.added(makeTx(amount: 1)))
        txRepoMock.changesSubject.send(.added(makeTx(amount: 2)))
        try? await Task.sleep(for: .milliseconds(40))

        // Assert
        #expect(received.first == 0)
        #expect(received.last == 3)
        _ = c
    }

    @Test("throttles repo writes (latest only within 1s window)")
    func throttlesWrites_latestOnly() async throws {
        // Arrange
        let balanceMock = BalanceRepoMock(balance: 0)
        let _di1 = MockDIContainer(type: BalanceRepo.self, service: balanceMock)

        let txRepoMock = TransactionRepoMock()
        let _di2 = MockDIContainer(type: TransactionRepo.self, service: txRepoMock)

        let sut = TransactionBasedBalanceService()
        try? await Task.sleep(for: .milliseconds(20)) // let setup() subscribe

        // Act: burst of quick updates inside one throttle window
        txRepoMock.changesSubject.send(.added(makeTx(amount: 0.1)))
        txRepoMock.changesSubject.send(.added(makeTx(amount: 0.2)))
        txRepoMock.changesSubject.send(.added(makeTx(amount: 0.3)))

        // Immediately after burst, no write yet due to throttle
        try? await Task.sleep(for: .milliseconds(3000))

        // Assert
        #expect(balanceMock.setBalanceArgValues.reduce(0, +) == 0.6)
        _ = sut
    }

    @Test("does not write unchanged balances (removeDuplicates)")
    func doesNotWriteUnchangedBalances() async {
        // Arrange
        let balanceMock = BalanceRepoMock(balance: 1) // initial = 1
        let _di1 = MockDIContainer(type: BalanceRepo.self, service: balanceMock)

        let txRepoMock = TransactionRepoMock()
        let _di2 = MockDIContainer(type: TransactionRepo.self, service: txRepoMock)

        let sut = TransactionBasedBalanceService()
        try? await Task.sleep(for: .milliseconds(30)) // allow initial emission

        // Act: send zero-amount transactions that keep balance at 1
        txRepoMock.changesSubject.send(.added(makeTx(amount: 0)))
        try? await Task.sleep(for: .milliseconds(1150)) // first throttle window ends

        // Assert (so far): one write for initial 1.0 only
        #expect(balanceMock.setBalanceCallCount == 1)
        #expect(balanceMock.setBalanceArgValues.last == 1)

        // Act again in a new window with still no balance change
        txRepoMock.changesSubject.send(.added(makeTx(amount: 0)))
        try? await Task.sleep(for: .milliseconds(1150))

        // Assert: still no additional writes, thanks to removeDuplicates upstream
        #expect(balanceMock.setBalanceCallCount == 1)
        _ = sut
    }
}
