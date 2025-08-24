//
//  BitcoinRateServiceImplTests.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine
import Testing
@testable import BitcoinWallet

@Suite("BitcoinRateServiceImpl Tests", .serialized)
struct BitcoinRateServiceImplTests {
    
    @Test("publishes initial fetch result on init")
    func publishesInitialFetch() async {
        // Arrange
        let provider = BitcoinRateProviderMock()
        provider.rateHandler = { 100.0 } // first fetch returns 100
        let _di = MockDIContainer(type: BitcoinRateProvider.self, service: provider)

        var received: [Double?] = []

        // Act
        let sut = BitcoinRateServiceImpl(interval: 10)
        let c = sut.rate.sink { received.append($0) }
        try? await Task.sleep(for: .milliseconds(40))

        // Assert
        #expect(received.last == 100.0)
        _ = c
        _ = sut
    }

    @Test("publishes periodic updates at the given interval")
    func publishesPeriodically() async {
        // Arrange
        let provider = BitcoinRateProviderMock()
        var queue: [Double] = [10.0, 20.0, 30.0] // immediate fetch + 2 ticks
        provider.rateHandler = {
            let v = queue.isEmpty ? queue.last ?? 30.0 : queue.removeFirst()
            return v
        }
        let _di = MockDIContainer(type: BitcoinRateProvider.self, service: provider)

        let sut = BitcoinRateServiceImpl(interval: 0.05)
        var received: [Double?] = []
        let c = sut.rate.sink { received.append($0) }

        // Act
        try? await Task.sleep(for: .milliseconds(140)) // ~1 immediate + ~2 ticks

        // Assert
        let nonNil = received.compactMap { $0 }
        // We expect the last three non-nil values to be 10, 20, 30 in order
        #expect(nonNil.suffix(3) == [10.0, 20.0, 30.0])
        _ = c
        _ = sut
    }
}
