//
//  BitcoinRateLocalRepo.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation

enum BitcoinRateLocalRepoError: Error {
    case noData
    case invalidData
}

class BitcoinRateLocalRepo: BitcoinRateRepo {
    
    typealias InternalError = BitcoinRateLocalRepoError
    
    var rate: Double {
        
        get async throws {
            
            let localRate = localRate
            
            guard localRate != 0 else {
                throw InternalError.noData
            }
            
            guard localRate > 0 else {
                throw InternalError.invalidData
            }
            
            return localRate
        }
    }
    
    func save(rate: Double) async throws {
        
        guard rate > 0 else {
            throw InternalError.invalidData
        }
        
        localRate = rate
    }
    
    private var userDefaults: UserDefaults { .standard }
    
    private var dataKey: String {
        "bitcoin.rate.local.repo.rate"
    }
    
    private var localRate: Double {
        
        get {
            userDefaults.double(forKey: dataKey)
        }
        set {
            userDefaults.set(newValue, forKey: dataKey)
        }
    }
}
