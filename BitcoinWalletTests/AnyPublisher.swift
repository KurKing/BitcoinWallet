//
//  AnyPublisher.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine
import Testing

enum TestingError: Error {
    case exceeded(Duration)
    case valueNotReceived
}

private func withTimeout<T>(_ limit: Duration,
                            operation: @escaping () async throws -> T) async throws -> T {
    
    try await withThrowingTaskGroup(of: T.self) { group in
        
        group.addTask { try await operation() }
        group.addTask {
            try await Task.sleep(for: limit)
            throw TestingError.exceeded(limit)
        }
        
        let result = try await group.next()!
        group.cancelAll()
        
        return result
    }
}

func awaitOutput<P: Publisher>(
    _ publisher: P,
    timeout: Duration = .seconds(5)
) async throws -> P.Output where P.Failure: Error {
    
    try await withTimeout(timeout) {
        
        for try await value in publisher.values {
            return value
        }
        
        throw TestingError.valueNotReceived
    }
}
