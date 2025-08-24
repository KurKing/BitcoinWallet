//
//  BTCRateModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

protocol BTCRateModel {
    var rate: AnyPublisher<Double?, Never> { get }
}

class DefaultBalanceModel: BTCRateModel {
    
    @Dependency private var rateService: BitcoinRateService
    
    var rate: AnyPublisher<Double?, Never> { rateService.rate }
}
