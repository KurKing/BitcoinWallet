//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

protocol BitcoinRateService: AnyObject {
    
    var onRateUpdate: ((Double) -> Void)? { get set }
}

final class BitcoinRateServiceImpl {
    
    var onRateUpdate: ((Double) -> Void)?
    
    // MARK: - Init
    
    init() {
        
    }
}

extension BitcoinRateServiceImpl: BitcoinRateService {
    
}
