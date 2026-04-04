//
//  Currency.swift
//  Models
//
//  Created by Justin Lee on 4/2/26.
//

import Foundation

public struct Currency: Identifiable, Hashable, Decodable {
    public let code: String
    
    public var id: String { code }
}

extension Currency {
    public var localizedName: String {
        Locale.current.localizedString(forCurrencyCode: code) ?? code
    }
}

extension Currency {
    public var flag: String {
        guard code.count == 3 else { return "🏳️" }
        
        let countryCode = String(code.prefix(2))
        return countryCode
            .unicodeScalars
            .map { 127397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}

extension Currency {
    public static let mockSelected: Currency = mockList[0]
    public static let mockList = Rate.mockList.map { rate in
        rate.foreignCurrency
    }
    
    public static let usd = Currency(code: "USD")
    public static let cop = Currency(code: "COP")
    public static let brl = Currency(code: "BRL")
    public static let mxn = Currency(code: "MXN")
    public static let ars = Currency(code: "ARS")
}


