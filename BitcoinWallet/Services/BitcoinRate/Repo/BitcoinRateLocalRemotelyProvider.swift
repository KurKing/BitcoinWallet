//
//  BitcoinRateLocalRemotelyProvider.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation

class BitcoinRateLocalRemotelyProvider: BitcoinRateProvider {
    
    var rate: Double {
        
        get async throws {
            try await fetchRate()
        }
    }
    
    private let remoteProvider: BitcoinRateProvider
    private let localRepo: BitcoinRateLocalRepo
    
    init(remoteProvider: BitcoinRateProvider = BitcoinRateRemoteProvider(),
         localRepo: BitcoinRateLocalRepo = BitcoinRateLocalRepo()) {
        
        self.remoteProvider = remoteProvider
        self.localRepo = localRepo
    }
    
    private func fetchRate() async throws -> Double {
        
        guard let remoteData = try? await remoteProvider.rate else {
            return try await localRepo.rate
        }
        
        try? await localRepo.save(rate: remoteData)
        
        return remoteData
    }
}
