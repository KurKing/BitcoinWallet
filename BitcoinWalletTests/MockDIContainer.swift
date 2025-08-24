//
//  MockDIContainer.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
@testable import BitcoinWallet

class MockDIContainer<T> {
    
    private let type: T.Type
    
    init(type: T.Type, service: T) {
        
        self.type = type
        DIContainer.shared.addSingleton(type: type, service: service)
    }
    
    deinit {
        DIContainer.shared.remove(type: type)
    }
}
