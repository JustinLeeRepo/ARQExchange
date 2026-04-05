//
//  ExchangeInputViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import Models
import SwiftUI

@Observable
class ExchangeInputViewModel {
    @ObservationIgnored
    lazy var usdExchangeInputRowViewModel: ExchangeInputRowViewModel = {
        ExchangeInputRowViewModel(currency: .usd, buySellSwapEventPublisher: buySellSwapEventSubject.eraseToAnyPublisher(), foreignCurrencySelectionSubject: foreignCurrencySelectionSubject, ratePublisher: ratePublisher, binding: usdBinding)
    }()
    
    @ObservationIgnored
    lazy var foreignExchangeInputRowViewModel: ExchangeInputRowViewModel = {
        ExchangeInputRowViewModel(currency: self.currency, buySellSwapEventPublisher: buySellSwapEventSubject.eraseToAnyPublisher(), foreignCurrencySelectionSubject: foreignCurrencySelectionSubject, ratePublisher: ratePublisher, binding: foreignBinding)
    }()
    
    var usdBinding: Binding<Double?> {
        Binding(
            get: { self.usdAmount },
            set: {
                self.usdAmount = $0 ?? 0
                self.foreignAmount = self.convert(usd: $0 ?? 0)
            }
        )
    }
    
    var foreignBinding: Binding<Double?> {
        Binding(
            get: { self.foreignAmount },
            set: {
                self.foreignAmount = $0 ?? 0
                self.usdAmount = self.reverseConvert(foreign: $0 ?? 0)
            }
        )
    }

    private var usdAmount: Double = 0
    private var foreignAmount: Double = 0
    
    private var currency: Currency
    private var rate: Rate?
    
    private let foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>
    private let buySellSwapEventSubject: PassthroughSubject<BuySellSwapEvent, Never>
    private let ratePublisher: AnyPublisher<Rate?, Never>
    private var cancellables = Set<AnyCancellable>()
    
    var isBuying: Bool = false
    
    init(foreignCurrency: Currency,
        buySellSwapEventSubject: PassthroughSubject<BuySellSwapEvent, Never>,
        foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>,
        ratePublisher: AnyPublisher<Rate?, Never>
    ) {
        self.currency = foreignCurrency
        self.foreignCurrencySelectionSubject = foreignCurrencySelectionSubject
        self.ratePublisher = ratePublisher
        self.buySellSwapEventSubject = buySellSwapEventSubject
        
        setupListener()
    }
    
    private func convert(usd: Double) -> Double {
        guard let rateValue = rateValue() else { print("no rate fetched"); return 0 }
        return usd * rateValue
    }
    
    private func reverseConvert(foreign: Double) -> Double {
        guard let rateValue = rateValue() else { print("no rate fetched reverse convert"); return 0 }
        guard rateValue != 0 else { return 0 }
        return foreign / rateValue
    }
    
    private func rateValue() -> Double? {
        guard let rate else { return nil }
        let raw = isBuying ? rate.bid : rate.ask
        return Double(raw)
    }
    
    private func setupListener() {
        foreignCurrencySelectionSubject.sink { [weak self] event in
            guard let self else { return }
            if case .selected(let currency) = event {
                self.currency = currency
            }
        }
        .store(in: &cancellables)
        
        ratePublisher.sink { [weak self] rate in
            guard let self else { return }
            self.rate = rate
            self.foreignAmount = self.convert(usd: self.usdAmount)
        }
        .store(in: &cancellables)

        buySellSwapEventSubject.sink { [weak self] event in
            guard let self else { return }
            self.isBuying = (event == .buy)
            self.foreignAmount = self.convert(usd: self.usdAmount)
        }
        .store(in: &cancellables)
    }
    
    func swapBuySell() {
        isBuying.toggle()
        buySellSwapEventSubject.send(isBuying ? .buy : .sell)
    }
}
