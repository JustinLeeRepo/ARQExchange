//
//  Rate.swift
//  Models
//
//  Created by Justin Lee on 4/2/26.
//

import Foundation

/*
 [
 {"ask":"17.8732000000","bid":"17.8623100000","book":"usdc_mxn","date":"2026-04-03T17:16:49.575779442"},
 {"ask":"1451.7900000000","bid":"1446.3750000000","book":"usdc_ars","date":"2026-04-03T17:16:49.638533749"},
 {"ask":"5.2034880000","bid":"5.1516125000","book":"usdc_brl","date":"2026-04-03T17:16:49.646171131"},
 {"ask":"3706.2354000000","bid":"3666.0400000000","book":"usdc_cop","date":"2026-04-03T17:16:49.653157384"}
 ]
 */

public struct Rate: Hashable, Decodable {
    public var ask: String
    public var bid: String
    var book: String
    var date: Date
}

extension Rate {
    public static let mockDict: [Currency: Rate] = mockList.reduce(into: [Currency: Rate]()) { partialResult, rate in
        partialResult[rate.foreignCurrency] = rate
    }
    
    public static let mockList = [
        mockARRate,
        mockBRRate,
        mockCORate,
        mockMXRate,
    ]
    
    public static let mockARRate = Rate(ask: "1551.0000000000", bid: "1539.4290300000", book: "usdc_ars", date: Date())
    public static let mockBRRate = Rate(ask: "5.2034880000", bid: "5.1516125000", book: "usdc_brl", date: Date())
    public static let mockCORate = Rate(ask: "3706.2354000000", bid: "3666.0400000000", book: "usdc_cop", date: Date())
    public static let mockMXRate = Rate(ask: "18.4105000000", bid: "18.4069700000", book: "usdc_mxn", date: Date())
}

extension Rate {
    var foreignCurrencyCode: String {
        String(book.split(separator: "_")[1]).uppercased()
    }
    
    public var foreignCurrency: Currency {
        Currency(code: foreignCurrencyCode)
    }
    
    public static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
}
