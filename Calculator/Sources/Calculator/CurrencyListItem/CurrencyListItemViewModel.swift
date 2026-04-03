//
//  CurrencyListItemViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 4/1/26.
//

import Combine
import SwiftUI

@Observable
class CurrencyListItemViewModel {
    let currency: Currency
    var isSelected: Bool
    
    let foreignCurrencySelectionSubject: PassthroughSubject<Currency, Never>
    var cancellables = Set<AnyCancellable>()
    
    init(currency: Currency,
         isSelected: Bool = false,
         foreignCurrencySelectionSubject: PassthroughSubject<Currency, Never>) {
        self.currency = currency
        self.isSelected = isSelected
        self.foreignCurrencySelectionSubject = foreignCurrencySelectionSubject
        
        setupListener()
    }
    
    var title: String {
        currency.code
    }
    
    func selectCurrency() {
        foreignCurrencySelectionSubject.send(currency)
    }
    
    private func setupListener() {
        foreignCurrencySelectionSubject.sink { [weak self] currency in
            guard let self = self else { return }
            if currency == self.currency {
                self.isSelected = true
            }
            else {
                self.isSelected = false
            }
        }
        .store(in: &cancellables)
    }
}
