//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Combine

protocol BitcoinRateService {
    var rate: CurrentValueSubject<Double?, Never> { get }
}

protocol BitcoinRateRepo {
    var rate: Double { get async throws }
}

final class BitcoinRateServiceImpl: BitcoinRateService {
    
    let rate = CurrentValueSubject<Double?, Never>(nil)
    
    @Dependency private var btc: BitcoinRateRepo
    
    init() {
        
        Task {
            
            let rate = try! await self.btc.rate
            
            self.rate.send(rate)
        }
    }
}
