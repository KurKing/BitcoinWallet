//
//  BitcoinRateAnalyticsDecorator.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

class BitcoinRateAnalyticsDecorator: BitcoinRateService {
    
    var rate: AnyPublisher<Double?, Never> { rateService.rate }
    
    @Dependency private var analyticsService: AnalyticsService
    private let rateService: BitcoinRateService
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(rateService: BitcoinRateService) {
        
        self.rateService = rateService
        
        rate.sink { [weak self] rate in
            
            self?.analyticsService.track(event: .btcRateUpdated,
                                         parameters: ["rate": "\(rate ?? 0)"])
        }
        .store(in: &cancellables)
    }
}
