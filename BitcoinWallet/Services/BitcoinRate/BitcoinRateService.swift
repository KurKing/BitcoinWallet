//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Combine

protocol BitcoinRateService: AnyObject {
    var rate: CurrentValueSubject<Double?, Never> { get }
}

protocol BitcoinRateRepo {
    var rate: Double { get async throws }
}

final class BitcoinRateServiceImpl: BitcoinRateService {
    
    let rate = CurrentValueSubject<Double?, Never>(nil)
    
    init() {
        
    }
}
