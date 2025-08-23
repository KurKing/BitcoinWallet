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
        
        DIContainer.shared.addSingleton(type: CoreDataContextProvider.self,
                                        service: DefaultCoreDataContextProvider())
        
        DIContainer.shared.addSingleton(type: TransactionRepo.self,
                                        service: TransactionCoreDataRepo())
        
        DIContainer.shared.addSingleton(type: BalanceRepo.self,
                                        service: BalanceCoreDataRepo())
        
        DIContainer.shared.addSingleton(type: BalanceService.self,
                                        service: TransactionBasedBalanceService())
        
        // setup dependecies
        _ = DIContainer.shared.resolve(type: BalanceService.self)
    }
}
//    // MARK: - AnalyticsService
//
//    static let analyticsService: PerformOnce<AnalyticsService> = {
//        let service = AnalyticsServiceImpl()
//
//        return { service }
//    }()
