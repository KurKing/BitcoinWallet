//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

enum ServicesAssembler {
    
    static func setupDI() {
        
        DIContainer.shared.addSingleton(type: AnalyticsService.self,
                                        service: DefaultAnalyticsService())
        
        DIContainer.shared.addFactory(type: BitcoinRateProvider.self) {
            BitcoinRateLocalRemotelyProvider()
        }
        
        DIContainer.shared.addFactory(type: BitcoinRateService.self) {
            BitcoinRateAnalyticsDecorator(rateService: BitcoinRateServiceImpl())
        }
        
        DIContainer.shared.addSingleton(type: CoreDataContextProvider.self,
                                        service: DefaultCoreDataContextProvider())
        
        DIContainer.shared
            .addSingleton(
                type: TransactionRepo.self,
                service: TransactionRepoAnalyticsDecorator(
                    repo: TransactionCoreDataRepo()
                )
            )
        
        DIContainer.shared.addSingleton(type: BalanceRepo.self,
                                        service: BalanceCoreDataRepo())
        
        DIContainer.shared.addSingleton(type: BalanceService.self,
                                        service: TransactionBasedBalanceService())
        
        // setup dependecies
        _ = DIContainer.shared.resolve(type: BalanceService.self)
        
        DIContainer.shared.addFactory(type: TransactionsGroupService.self) {
            DefaultTransactionsGroupService()
        }
    }
}
