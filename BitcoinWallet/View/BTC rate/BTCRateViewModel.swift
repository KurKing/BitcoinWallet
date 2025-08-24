//
//  BTCRateViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

/// @mockable
protocol BTCRateViewModel {
    var rate: AnyPublisher<String, Never> { get }
}

class DefaultBTCRateViewModel: BTCRateViewModel {
    
    var rate: AnyPublisher<String, Never> {
        
        model.rate
            .map({ rate in
            
                if let rate {
                    return "\(rate)$"
                }
                
                return "Loading BTC rate..."
            })
            .eraseToAnyPublisher()
    }
    
    private let model: BTCRateModel
    
    init(model: BTCRateModel = DefaultBalanceModel()) {
        self.model = model
    }
}
