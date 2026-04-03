//
//  ExchangeHeaderViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import SwiftUI

@Observable
class ExchangeHeaderViewModel {
    let buySellSwapEventPublisher: AnyPublisher<BuySellSwapEvent, Never>
    let foreignCurrencySelectionPublisher: AnyPublisher<Currency, Never>
    var cancellables = Set<AnyCancellable>()
    
    var currency: Currency
    
    var rate: String {
        "1000"
    }
    
    var foreignCurrency: String {
        currency.code
    }
    
    var exchangeRate: String {
        return "1 USD = \(rate) \(foreignCurrency)"
    }
    
    init(foreignCurrency: Currency = .mxn, buySellSwapEventPublisher: AnyPublisher<BuySellSwapEvent, Never>, foreignCurrencySelectionPublisher: AnyPublisher<Currency, Never>) {
        self.currency = foreignCurrency
        self.buySellSwapEventPublisher = buySellSwapEventPublisher
        self.foreignCurrencySelectionPublisher = foreignCurrencySelectionPublisher
        
        setupListener()
    }
    
    private func setupListener() {
        buySellSwapEventPublisher.sink { event in
            
        }
        .store(in: &cancellables)
        
        foreignCurrencySelectionPublisher.sink { event in
            Task { @MainActor in
                self.currency = event
            }
        }
        .store(in: &cancellables)
    }
}
