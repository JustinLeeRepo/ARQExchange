//
//  ExchangeHeaderViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import Models
import SwiftUI

@Observable
class ExchangeHeaderViewModel {
    private let buySellSwapEventPublisher: AnyPublisher<BuySellSwapEvent, Never>
    private let foreignCurrencySelectionPublisher: AnyPublisher<ForeignCurrencySelectionEvent, Never>
    private let ratePublisher: AnyPublisher<Rate?, Never>
    private var cancellables = Set<AnyCancellable>()
    
    private var isBuying = false
    
    var currency: Currency
    var rate: Rate?
    
    var foreignCurrency: String {
        currency.code
    }
    
    var exchangeRate: String {
        guard let rate else { return "Loading..." }
        let currentRate = isBuying ? rate.bid : rate.ask
        return "1 USD = \(currentRate) \(foreignCurrency)"
    }
    
    init(foreignCurrency: Currency, buySellSwapEventPublisher: AnyPublisher<BuySellSwapEvent, Never>, foreignCurrencySelectionPublisher: AnyPublisher<ForeignCurrencySelectionEvent, Never>, ratePublisher: AnyPublisher<Rate?, Never>) {
        self.currency = foreignCurrency
        self.buySellSwapEventPublisher = buySellSwapEventPublisher
        self.foreignCurrencySelectionPublisher = foreignCurrencySelectionPublisher
        self.ratePublisher = ratePublisher
        
        setupListener()
    }
    
    private func setupListener() {
        ratePublisher.sink { [weak self] event in
            guard let self else { return }
            Task { @MainActor in
                self.rate = event
            }
        }
        .store(in: &cancellables)
        
        buySellSwapEventPublisher.sink { [weak self] event in
            guard let self else { return }
            self.isBuying = event == .buy
        }
        .store(in: &cancellables)
        
        foreignCurrencySelectionPublisher.sink { [weak self] event in
            guard let self else { return }
            if case .selected(let currency) = event {
                Task { @MainActor in
                    self.currency = currency
                }
            }
        }
        .store(in: &cancellables)
    }
}
