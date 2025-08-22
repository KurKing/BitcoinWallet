//
//  BitcoinRateRemoteRepo.swift
//  BitcoinWallet
//
//  Created by Oleksii on 22.08.2025.
//

import Foundation

class BitcoinRateRemoteRepo: BitcoinRateRepo {
    
    var rate: Double {
        get async throws {
            try await fetchRate()
        }
    }
    
    private func fetchRate() async throws -> Double { 12 }
}
