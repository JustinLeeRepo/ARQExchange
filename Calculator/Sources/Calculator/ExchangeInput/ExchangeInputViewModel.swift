//
//  ExchangeInputViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import SwiftUI

@Observable
class ExchangeInputViewModel {
    let usdExchangeInputRowViewModel: ExchangeInputRowViewModel
    let foreignExchangeInputRowViewModel: ExchangeInputRowViewModel
    
    let buySellSwapEventSubject: PassthroughSubject<BuySellSwapEvent, Never>
    let foreignCurrencySelectionSubject: PassthroughSubject<Currency, Never>
    var cancellables = Set<AnyCancellable>()
    
    var isBuying: Bool = false
    
    init(
        buySellSwapEventSubject: PassthroughSubject<BuySellSwapEvent, Never>,
        foreignCurrencySelectionSubject: PassthroughSubject<Currency, Never>
    ) {
        self.buySellSwapEventSubject = buySellSwapEventSubject
        self.foreignCurrencySelectionSubject = foreignCurrencySelectionSubject
        
        let buySellSwapEventPublisher = buySellSwapEventSubject.eraseToAnyPublisher()
        self.usdExchangeInputRowViewModel = ExchangeInputRowViewModel(currency: .usd, buySellSwapEventPublisher: buySellSwapEventPublisher, foreignCurrencySelectionSubject: foreignCurrencySelectionSubject)
        self.foreignExchangeInputRowViewModel = ExchangeInputRowViewModel(currency: .ars, buySellSwapEventPublisher: buySellSwapEventPublisher, foreignCurrencySelectionSubject: foreignCurrencySelectionSubject)
    }
    
    func swapBuySell() {
        isBuying.toggle()
        buySellSwapEventSubject.send(isBuying ? .buy : .sell)
    }
}
