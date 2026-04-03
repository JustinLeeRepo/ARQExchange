//
//  Currency.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Foundation

struct Currency: Identifiable, Hashable, Decodable {
    let code: String
    
    var id: String { code }
}

extension Currency {
    var localizedName: String {
        Locale.current.localizedString(forCurrencyCode: code) ?? code
    }
}

extension Currency {
    var flag: String {
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
    static let usd = Currency(code: "USD")
    static let cop = Currency(code: "COP")
    static let brl = Currency(code: "BRL")
    static let mxn = Currency(code: "MXN")
    static let ars = Currency(code: "ARS")
}
