//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Combine

protocol BitcoinRateService {
    var rate: CurrentValueSubject<Double?, Never> { get }
}

final class BitcoinRateServiceImpl: BitcoinRateService {
    
    let rate = CurrentValueSubject<Double?, Never>(nil)
    
    @Dependency private var btc: BitcoinRateProvider
    
    init() {
        
        Task {
            
            let rate = try! await self.btc.rate
            
            self.rate.send(rate)
        }
    }
}
