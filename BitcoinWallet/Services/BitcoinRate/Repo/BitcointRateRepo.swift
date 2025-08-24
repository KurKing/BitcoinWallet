//
//  BitcointRateRepo.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation

/// @mockable
protocol BitcoinRateProvider {
    var rate: Double { get async throws }
}

/// @mockable
protocol BitcoinRateRepo: BitcoinRateProvider {
    func save(rate: Double) async throws
}
