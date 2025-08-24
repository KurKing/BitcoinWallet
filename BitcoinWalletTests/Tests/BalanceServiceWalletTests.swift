//
//  BalanceServiceWalletTests.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine
import Testing
@testable import BitcoinWallet

@Suite("BalanceServiceWallet Tests", .serialized)
struct BalanceServiceWalletTests {

    @Test("default init emits 0 and balance == 0")
    func defaultInit_emitsZero() async {
        // Arrange
        let sut = BalanceServiceWallet()
        var received: [Decimal] = []
        let c = sut.balancePublisher.sink { received.append($0) }

        // Act
        try? await Task.sleep(for: .milliseconds(5))
        let current = await sut.balance

        // Assert
        #expect(current == 0)
        #expect(received.first == 0)
        _ = c
    }

    @Test("single deposit updates balance and emits new value")
    func deposit_once_updates() async {
        // Arrange
        let sut = BalanceServiceWallet(initialBalance: Decimal(1.5))
        var received: [Decimal] = []
        let c = sut.balancePublisher.sink { received.append($0) }

        // Act
        await sut.deposit(Decimal(0.5))
        try? await Task.sleep(for: .milliseconds(10))
        let current = await sut.balance

        // Assert
        #expect(current == Decimal(2.0))
        #expect(received == [Decimal(1.5), Decimal(2.0)])
        _ = c
    }

    @Test("multiple deposits emit each step and accumulate")
    func deposit_multiple_emitsEachStep() async {
        // Arrange
        let sut = BalanceServiceWallet(initialBalance: Decimal(2))
        var received: [Decimal] = []
        let c = sut.balancePublisher.sink { received.append($0) }

        // Act
        await sut.deposit(Decimal(1))   // -> 3
        await sut.deposit(Decimal(2))   // -> 5
        try? await Task.sleep(for: .milliseconds(10))
        let current = await sut.balance

        // Assert
        #expect(current == Decimal(5))
        #expect(received == [Decimal(2), Decimal(3), Decimal(5)])
        _ = c
    }

    @Test("concurrent deposits are serialized by the actor")
    func concurrentDeposits_areSerialized() async {
        // Arrange
        let sut = BalanceServiceWallet(initialBalance: Decimal(0))
        var received: [Decimal] = []
        let c = sut.balancePublisher.sink { received.append($0) }

        // Act
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<10 {
                group.addTask { await sut.deposit(Decimal(1)) }
            }
            await group.waitForAll()
        }
        try? await Task.sleep(for: .milliseconds(15))
        let current = await sut.balance

        // Assert
        #expect(current == Decimal(10))
        // Should have initial + 10 emissions total
        #expect(received.count == 1 /* initial 0 */ + 10)
        #expect(received.first == 0)
        #expect(received.last == 10)
        _ = c
    }
}
