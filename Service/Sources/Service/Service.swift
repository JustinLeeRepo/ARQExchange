// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

enum ExchangeError: LocalizedError {
    case currencyError(Error)
    case rateError(Error)
    
    var localizedDescription: String? {
        switch self {
        case .currencyError:
            return "Error fetching currencies"
        case .rateError:
            return "Error fetching rates"
        }
    }
}
