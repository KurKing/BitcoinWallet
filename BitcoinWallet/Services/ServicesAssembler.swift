//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

enum ServicesAssembler {
    
    static func setupDI() {
        
        DIContainer.shared.addFactory(type: BitcoinRateProvider.self) {
            BitcoinRateLocalRemotelyProvider()
        }
        
        DIContainer.shared.addFactory(type: BitcoinRateService.self) {
            BitcoinRateServiceImpl()
        }
    }
//    // MARK: - BitcoinRateService
//    
//    static let bitcoinRateService: PerformOnce<BitcoinRateService> = {
//        lazy var analyticsService = Self.analyticsService()
//        
//        let service = BitcoinRateServiceImpl()
//        
//        service.onRateUpdate = {
//            analyticsService.trackEvent(
//                name: "bitcoin_rate_update",
//                parameters: ["rate": String(format: "%.2f", $0)]
//            )
//        }
//        
//        return { service }
//    }()
//    
//    // MARK: - AnalyticsService
//    
//    static let analyticsService: PerformOnce<AnalyticsService> = {
//        let service = AnalyticsServiceImpl()
//        
//        return { service }
//    }()
}
