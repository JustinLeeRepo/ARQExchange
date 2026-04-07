//
//  RateService.swift
//  Service
//
//  Created by Justin Lee on 4/2/26.
//

import Foundation
import MilaNetwork
import Models

public protocol RateServicable {
    func fetchRates(currency: [Currency]) async throws -> [Rate]
}

struct RateEndpoint: APIEndpoint {
    let foreignCurrency: [Currency]
    let dateFormatter = DateFormatter()
    var base: String {
        "https://api.dolarapp.dev"
        // /v1/tickers?currencies=MXN,ARS
    }
    
    var path: String {
        "v1/tickers"
    }
    
    var queryItems: [URLQueryItem]? {
        let codes = foreignCurrency.compactMap {$0.code}.joined(separator: ",").uppercased()
        return [URLQueryItem(name: "currencies", value: codes)]
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
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        dateFormatter.dateFormat = Rate.dateFormat
        return .formatted(dateFormatter)
    }
}

public class RateService: RateServicable {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func fetchRates(currency: [Currency]) async throws -> [Rate] {
        let endpoint = RateEndpoint(foreignCurrency: currency)
        do {
            let response: [Rate] = try await networkService.performRequest(endpoint)
            return response
        }
        catch {
            throw ExchangeError.rateError(error)
        }
    }
}

public class MockRateService: RateServicable {
    public init() {}
    public func fetchRates(currency: [Currency]) async throws -> [Rate] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return Rate.mockList
    }
}
