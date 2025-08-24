//
//  DIContainer.swift
//  BitcoinWallet
//
//  Created by Oleksii on 22.08.2025.
//

@propertyWrapper
struct Dependency<T> {
    
    private let container: DIContainer
    
    init() {
        self.container = .shared
    }
    
    lazy var wrappedValue: T = container.resolve(type: T.self)
}

final class DIContainer {
    
    static let shared = DIContainer()
    
    private var registrations: [String: AnyObject] = [:]
    
    private init() { /* ... */ }
    
    func addFactory<T>(type: T.Type, creator: @escaping () -> T) {
        
        let key = String(describing: type)
        registrations[key] = DIRegistration(serviceType: type, serviceCreation: creator)
    }
    
    func addSingleton<T>(type: T.Type, service: T) {
        
        let key = String(describing: type)
        registrations[key] = DIRegistration(serviceType: type, service: service)
    }
    
    func remove<T>(type: T.Type) {
        
        let key = String(describing: type)
        registrations[key] = nil
    }
        
    func resolve<T>(type: T.Type) -> T {
        
        let key = String(describing: type)

        guard let registration = registrations[key] as? DIRegistration<T> else {
            fatalError("Service with type \(type) not found.")
        }
        
        return registration.service
    }
}

private final class DIRegistration<T> {
    
    let serviceType: T.Type
    private let serviceCreation: DIRegistrationType<T>
    
    init(serviceType: T.Type, serviceCreation: @escaping () -> T) {
        
        self.serviceType = serviceType
        self.serviceCreation = .factory(creator: serviceCreation)
    }
    
    init(serviceType: T.Type, service: T) {
        
        self.serviceType = serviceType
        self.serviceCreation = .singleton(service: service)
    }
    
    var service: T {
        
        switch serviceCreation {
        case .singleton(let service):
            service
        case .factory(let creator):
            creator()
        }
    }
}

private enum DIRegistrationType<T> {
    
    case singleton(service: T)
    case factory(creator: () -> T)
}
