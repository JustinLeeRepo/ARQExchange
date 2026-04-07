//
//  CurrencyService.swift
//  Service
//
//  Created by Justin Lee on 4/2/26.
//

import Foundation
import MilaNetwork
import Models

public protocol CurrencyServicable {
    var placeholderCurrencies: [Currency] { get }
    func fetchCurrencies() async throws -> [Currency]
}

struct CurrencyEndpoint: APIEndpoint {
    var base: String {
        "https://api.dolarapp.dev"
        // /v1/tickers-currencies
    }
    
    var path: String {
        "v1/tickers-currencies"
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var body: Encodable? {
        return nil
    }
    
    var authToken: String? {
        return nil
    }
}

struct CurrencyResponse: Decodable {
    var currencies: [Currency]
}

public class FallbackCurrencyService: CurrencyServicable {
    let primary: CurrencyServicable
    let fallback: CurrencyServicable
    
    public init(networkService: NetworkServiceProtocol) {
        self.primary = CurrencyService(networkService: networkService)
        self.fallback = MockCurrencyService()
    }
    
    public var placeholderCurrencies: [Currency] {
        Currency.mockList
    }
    
    public func fetchCurrencies() async throws -> [Currency] {
        do {
            return try await primary.fetchCurrencies()
        } catch {
            return try await fallback.fetchCurrencies()
        }
    }
}

class CurrencyService: CurrencyServicable {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    var placeholderCurrencies: [Currency] = Currency.mockList
    
    func fetchCurrencies() async throws -> [Currency] {
        let endpoint: CurrencyEndpoint = CurrencyEndpoint()
        do {
            let response: CurrencyResponse = try await networkService.performRequest(endpoint)
            return response.currencies
        }
        catch {
            throw ExchangeError.currencyError(error)
        }
    }
}

public class MockCurrencyService: CurrencyServicable {
    public init() {}
    public var placeholderCurrencies: [Currency] = Currency.mockList
    
    public func fetchCurrencies() async throws -> [Currency] {
        try await Task.sleep(nanoseconds: 1_000_000)
        
        return placeholderCurrencies
    }
}
