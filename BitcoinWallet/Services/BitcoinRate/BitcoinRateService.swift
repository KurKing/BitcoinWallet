//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

protocol BitcoinRateService {
    var rate: CurrentValueSubject<Double?, Never> { get }
}

final class BitcoinRateServiceImpl: BitcoinRateService {
    
    let rate = CurrentValueSubject<Double?, Never>(nil)
    
    @Dependency private var rateProvider: BitcoinRateProvider
    
    private var timer: Task<Void, Never>?

    init(interval: TimeInterval = 60) {
        
        timer = Task {
            
            await fetchAndPublish()
            
            for await _ in Timer
                .publish(every: interval, on: .main, in: .common)
                .autoconnect()
                .values {
                await fetchAndPublish()
            }
        }
    }
    
    private func fetchAndPublish() async {
        
        let rate = try? await rateProvider.rate
        self.rate.send(rate)
    }
}
