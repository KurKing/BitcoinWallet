//
//  BalanceRepo.swift
//  BitcoinWallet
//
//  Created by Oleksii on 23.08.2025.
//

import Foundation

protocol BalanceRepo {
    
    var balance: BalanceDataModel { get async }
    
    func setBalance(_ balance: BalanceDataModel) async throws
}
