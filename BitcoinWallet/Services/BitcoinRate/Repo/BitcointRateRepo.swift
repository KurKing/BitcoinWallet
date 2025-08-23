//
//  BitcointRateRepo.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation

protocol BitcoinRateProvider {
    var rate: Double { get async throws }
}

protocol BitcoinRateRepo: BitcoinRateProvider {
    func save(rate: Double) async throws
}
