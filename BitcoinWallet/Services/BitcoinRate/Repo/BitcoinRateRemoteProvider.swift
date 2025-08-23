//
//  BitcoinRateRemoteProvider.swift
//  BitcoinWallet
//
//  Created by Oleksii on 22.08.2025.
//

import Foundation

enum BitcoinRateRemoteProviderError: Error {
    
    case invalidURL
    case badResponse
    case pasingError
}

class BitcoinRateRemoteProvider: BitcoinRateProvider {
    
    private typealias InternalError = BitcoinRateRemoteProviderError
    
    var rate: Double {
        get async throws {
            try await fetchRate()
        }
    }
    
    private func fetchRate() async throws -> Double {
        
        let urlString = "https://binance43.p.rapidapi.com/avgPrice?symbol=BTCUSDT"
        
        guard let url = URL(string: urlString) else {
            throw InternalError.invalidURL
        }
        
        var request = URLRequest(url: url, timeoutInterval: 3)
        
        request.addValue(Keys.rapidApiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(Keys.rapidApiHost, forHTTPHeaderField: "x-rapidapi-host")
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw InternalError.badResponse
        }
        
        guard let responseModel = try? JSONDecoder().decode(APIResponseModel.self,
                                                            from: data),
              let doubleResponse = Double(responseModel.price) else {
            throw InternalError.pasingError
        }
        
        return doubleResponse
    }
    
    private struct APIResponseModel: Decodable {
        let price: String
    }
}
