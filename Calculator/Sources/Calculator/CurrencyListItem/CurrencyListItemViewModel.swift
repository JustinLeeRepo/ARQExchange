//
//  CurrencyListItemViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 4/1/26.
//

import Combine
import Models
import SwiftUI

@Observable
class CurrencyListItemViewModel {
    let currency: Currency
    var isSelected: Bool
    
    let foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>
    var cancellables = Set<AnyCancellable>()
    
    init(currency: Currency,
         isSelected: Bool = false,
         foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>) {
        self.currency = currency
        self.isSelected = isSelected
        self.foreignCurrencySelectionSubject = foreignCurrencySelectionSubject
        
        setupListener()
    }
    
    var title: String {
        currency.code
    }
    
    func selectCurrency() {
        foreignCurrencySelectionSubject.send(.selected(currency))
    }
    
    private func setupListener() {
        foreignCurrencySelectionSubject.sink { [weak self] event in
            guard let self = self else { return }
            if case .selected(let currency) = event {
                self.isSelected = currency == self.currency
            }
        }
        .store(in: &cancellables)
    }
}
