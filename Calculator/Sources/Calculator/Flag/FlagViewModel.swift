//
//  FlagViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import Models
import SwiftUI

@Observable
class FlagViewModel {
    let foreignCurrencySelectionPublisher: AnyPublisher<ForeignCurrencySelectionEvent, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    var currency: Currency
    
    var flagEmoji: String {
        currency.flag
    }
    
    init(
        currency: Currency,
        foreignCurrencySelectionPublisher: AnyPublisher<ForeignCurrencySelectionEvent, Never>? = nil
    ) {
        self.currency = currency
        self.foreignCurrencySelectionPublisher = foreignCurrencySelectionPublisher
        setupListener()
    }
    
    private func setupListener() {
        guard let publisher = foreignCurrencySelectionPublisher else { return }
        publisher.sink { [weak self] event in
            guard let self else { return }
            if case .selected(let currency) = event {
                self.currency = currency
            }
        }
        .store(in: &cancellables)
    }
}
