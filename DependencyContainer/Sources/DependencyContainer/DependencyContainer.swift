// The Swift Programming Language
// https://docs.swift.org/swift-book


import MilaNetwork
import Service

public protocol DependencyContainable {
    func getRateService() -> RateServicable
    func getCurrencyService() -> CurrencyServicable
}

public class DependencyContainer: DependencyContainable {
    private let networkService: NetworkServiceProtocol
    private let rateService: RateServicable
    private let currencyService: CurrencyServicable
    
    public static let shared = DependencyContainer()
    
    private init() {
        self.networkService = NetworkService()
        self.rateService = RateService(networkService: networkService)
        self.currencyService = FallbackCurrencyService(networkService: networkService)
    }
    
    public func getRateService() -> RateServicable {
        rateService
    }
    
    public func getCurrencyService() -> CurrencyServicable {
        currencyService
    }
}


public class MockDependencyContainer: DependencyContainable {
    private let rateService: RateServicable = MockRateService()
    private let currencyService: CurrencyServicable = MockCurrencyService()
    
    public init() {}
    
    public func getRateService() -> RateServicable {
        rateService
    }
    
    public func getCurrencyService() -> CurrencyServicable {
        currencyService
    }
}
