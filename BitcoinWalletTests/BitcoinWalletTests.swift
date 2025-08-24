//
//  BitcoinWalletTests.swift
//  BitcoinWalletTests
//
//  Created by Oleksii on 21.08.2025.
//

import Testing
@testable import BitcoinWallet

@Suite("BitcoinWallet Tests", .serialized)
struct BitcoinWalletTests {
    
    @Test("Test example")
    func testExample() async throws {
        
        let balanceRepoMock = BalanceRepoMock(balance: 2)
        
        let mockContainer1 = MockDIContainer(type: BalanceRepo.self,
                                             service: balanceRepoMock)
        
        let transactionRepoMock = TransactionRepoMock()
        
        let mockContainer2 = MockDIContainer(type: TransactionRepo.self,
                                             service: transactionRepoMock)
        
        let sut = TransactionBasedBalanceService()
        
        let value = try await awaitOutput(sut.balance)
        
        #expect(value == 2)
    }
}
