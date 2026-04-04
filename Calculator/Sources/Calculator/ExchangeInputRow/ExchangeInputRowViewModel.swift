//
//  ExchangeInputRowViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import Models
import SwiftUI

@Observable
class ExchangeInputRowViewModel {
    let amount: Binding<Double>
    private var currency: Currency
    let isLocked: Bool
    let flagViewModel: FlagViewModel
    
    private var isBuying = false
    private var rate: Rate?
    private let ratePublisher: AnyPublisher<Rate?, Never>
    private let buySellSwapEventPublisher: AnyPublisher<BuySellSwapEvent, Never>
    private let foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    
    
    init(
        currency: Currency,
        amount: Double = 0.00,
        buySellSwapEventPublisher: AnyPublisher<BuySellSwapEvent, Never>,
        foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>,
        ratePublisher: AnyPublisher<Rate?, Never>,
        binding: Binding<Double>
    ) {
        self.currency = currency
        self.isLocked = currency == .usd
        self.buySellSwapEventPublisher = buySellSwapEventPublisher
        self.foreignCurrencySelectionSubject = foreignCurrencySelectionSubject
        self.ratePublisher = ratePublisher
        self.flagViewModel = FlagViewModel(currency: currency, foreignCurrencySelectionPublisher: isLocked ? nil : foreignCurrencySelectionSubject.eraseToAnyPublisher())
        self.amount = binding
        setupListener()
    }
    
    var currencyCode: String {
        currency.code
    }
    
//    var amountDisplay: String {
//        if amount == 0 { return isLocked ? "$0" : "" }
//        let prefix = isLocked ? "$" : "$"
//        return "\(prefix)\(amount)"
//    }
    
    private func setupListener() {
        if !isLocked {
            foreignCurrencySelectionSubject.sink { [weak self] currency in
                guard let self = self else { return }
                if case .selected(let currency) = currency {
                    self.currency = currency                    
                }
            }
            .store(in: &cancellables)
        }
        
        buySellSwapEventPublisher.sink { [weak self] event in
            guard let self else { return }
            self.isBuying = event == .buy
        }
        .store(in: &cancellables)
        
        ratePublisher.sink { [weak self] event in
            self?.rate = event
        }
        .store(in: &cancellables)
    }
    
    func openCurrencySelectionSheet() {
        foreignCurrencySelectionSubject.send(.open)
    }
    
    func convertedAmount(from usdAmount: Double) -> Double {
        guard let rate else { return 0 }
        let rateString = isBuying ? rate.bid : rate.ask
        guard let rateValue = Double(rateString) else { return 0 }
        return usdAmount * rateValue
    }
}
