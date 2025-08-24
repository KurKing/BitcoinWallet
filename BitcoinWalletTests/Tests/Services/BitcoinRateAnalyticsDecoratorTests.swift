//
//  BitcoinRateAnalyticsDecoratorTests.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine
import Testing
@testable import BitcoinWallet

@Suite("BitcoinRateAnalyticsDecorator Tests", .serialized)
struct BitcoinRateAnalyticsDecoratorTests {

    @Test("tracks event on non-nil rate emission")
    func tracks_onNonNilRate() async {
        // Arrange
        let analyticsMock = AnalyticsServiceMock()
        let _di = MockDIContainer(type: AnalyticsService.self, service: analyticsMock)

        let rateMock = BitcoinRateServiceMock()
        let sut = BitcoinRateAnalyticsDecorator(rateService: rateMock)

        // Act
        rateMock.rateSubject.send(1234.5)
        // Give Combine a tiny moment to deliver the sink
        try? await Task.sleep(for: .milliseconds(20))

        // Assert
        #expect(analyticsMock.trackCallCount == 1)
        #expect(analyticsMock.trackArgValues.first?.event == .btcRateUpdated)
        #expect(analyticsMock.trackArgValues.first?.parameters == ["rate": "1234.5"])
        _ = sut // keep alive
    }

    @Test("tracks zero when rate is nil")
    func tracks_zeroOnNilRate() async {
        // Arrange
        let analyticsMock = AnalyticsServiceMock()
        let _di = MockDIContainer(type: AnalyticsService.self, service: analyticsMock)

        let rateMock = BitcoinRateServiceMock()
        let sut = BitcoinRateAnalyticsDecorator(rateService: rateMock)

        // Act
        rateMock.rateSubject.send(nil)
        try? await Task.sleep(for: .milliseconds(20))

        // Assert
        #expect(analyticsMock.trackCallCount == 1)
        #expect(analyticsMock.trackArgValues.first?.event == .btcRateUpdated)
        // "\(rate ?? 0)" → "0.0" for Double interpolation
        #expect(analyticsMock.trackArgValues.first?.parameters == ["rate": "0.0"])
        _ = sut
    }

    @Test("forwards rate output from inner service")
    func forwards_rateOutput() async {
        // Arrange
        let _di = MockDIContainer(type: AnalyticsService.self, service: AnalyticsServiceMock())
        let rateMock = BitcoinRateServiceMock()
        let sut = BitcoinRateAnalyticsDecorator(rateService: rateMock)

        var received = [Double?]()
        let c = sut.rate.sink { received.append($0) }

        // Act
        rateMock.rateSubject.send(1.0)
        rateMock.rateSubject.send(nil)
        rateMock.rateSubject.send(2.5)
        try? await Task.sleep(for: .milliseconds(30))

        // Assert
        #expect(received == [1.0, nil, 2.5])
        _ = c
    }

    @Test("tracks on every emission with latest parameters")
    func tracks_onEveryEmission() async {
        // Arrange
        let analyticsMock = AnalyticsServiceMock()
        let _di = MockDIContainer(type: AnalyticsService.self, service: analyticsMock)

        let rateMock = BitcoinRateServiceMock()
        let sut = BitcoinRateAnalyticsDecorator(rateService: rateMock)

        // Act
        rateMock.rateSubject.send(0.1)
        rateMock.rateSubject.send(0.2)
        rateMock.rateSubject.send(0.3)
        try? await Task.sleep(for: .milliseconds(30))

        // Assert
        #expect(analyticsMock.trackCallCount == 3)
        let params = analyticsMock.trackArgValues.map { $0.parameters["rate"] }
        #expect(params == ["0.1", "0.2", "0.3"])
        _ = sut
    }
}
