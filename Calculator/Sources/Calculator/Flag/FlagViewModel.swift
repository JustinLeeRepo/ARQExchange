//
//  FlagViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import SwiftUI

@Observable
class FlagViewModel {
    let foreignCurrencySelectionPublisher: AnyPublisher<Currency, Never>?
    var cancellables = Set<AnyCancellable>()
    
    var currency: Currency
    
    var flagEmoji: String {
        currency.flag
    }
    
    init(
        currency: Currency,
        foreignCurrencySelectionPublisher: AnyPublisher<Currency, Never>? = nil
    ) {
        self.currency = currency
        self.foreignCurrencySelectionPublisher = foreignCurrencySelectionPublisher
        setupListener()
    }
    
    private func setupListener() {
        guard let publisher = foreignCurrencySelectionPublisher else { return }
        publisher.sink { event in
            self.currency = event
        }
        .store(in: &cancellables)
    }
}
