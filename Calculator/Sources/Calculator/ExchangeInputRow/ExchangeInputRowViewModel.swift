//
//  ExchangeInputRowViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import SwiftUI

@Observable
class ExchangeInputRowViewModel {
    private var currency: Currency
    var amount: Double
    let isLocked: Bool
    var isCurrenncySheetOpen = false
    let flagViewModel: FlagViewModel
    let currencyListViewModel: CurrencyListViewModel
    
    private let buySellSwapEventPublisher: AnyPublisher<BuySellSwapEvent, Never>
    private let foreignCurrencySelectionPublisher: AnyPublisher<Currency, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(
        currency: Currency,
        amount: Double = 0.00,
        buySellSwapEventPublisher: AnyPublisher<BuySellSwapEvent, Never>,
        foreignCurrencySelectionSubject: PassthroughSubject<Currency, Never>
    ) {
        self.currency = currency
        self.amount = amount
        self.isLocked = currency == .usd
        self.currencyListViewModel = CurrencyListViewModel(selectedCurrency: currency, foreignCurrencySelectionSubject: foreignCurrencySelectionSubject)
        self.buySellSwapEventPublisher = buySellSwapEventPublisher
        self.foreignCurrencySelectionPublisher = foreignCurrencySelectionSubject.eraseToAnyPublisher()
        self.flagViewModel = FlagViewModel(currency: currency, foreignCurrencySelectionPublisher: isLocked ? nil : foreignCurrencySelectionPublisher)
        
        setupListener()
    }
    
    var currencyCode: String {
        currency.code
    }
    
    var amountDisplay: String {
        if amount == 0 { return isLocked ? "$0" : "" }
        let prefix = isLocked ? "$" : "$"
        return "\(prefix)\(amount)"
    }
    
    private func setupListener() {
        if !isLocked {
            foreignCurrencySelectionPublisher.sink { [weak self] currency in
                guard let self = self else { return }
                self.currency = currency
                self.isCurrenncySheetOpen = false
            }
            .store(in: &cancellables)
        }
        
        buySellSwapEventPublisher.sink { event in
            
        }
        .store(in: &cancellables)
    }
    
    func openCurrencySelectionSheet() {
        isCurrenncySheetOpen = true
    }
}
