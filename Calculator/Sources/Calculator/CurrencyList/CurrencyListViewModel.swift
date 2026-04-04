//
//  CurrencyListViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 4/1/26.
//

import Combine
import Models
import SwiftUI

//add service to fetch available currencies here
@Observable
class CurrencyListViewModel {
    var currencies = [Currency]()
    private var selectedCurrency: Currency
    private let foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(selectedCurrency: Currency, foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>) {
        self.selectedCurrency = selectedCurrency
        self.foreignCurrencySelectionSubject = foreignCurrencySelectionSubject
        
        setupListener()
    }
    
    func listItemViewModel(for currency: Currency) -> CurrencyListItemViewModel {
        .init(currency: currency, isSelected: selectedCurrency == currency, foreignCurrencySelectionSubject: foreignCurrencySelectionSubject)
    }
    
    func closeSheet() {
        //send currency selected with selectedCurrency
        foreignCurrencySelectionSubject.send(.close)
    }
    
    private func setupListener() {
        foreignCurrencySelectionSubject.sink { [weak self] event in
            guard let self = self else { return }
            if case .selected(let currency) = event {
                self.selectedCurrency = currency
            }
        }
        .store(in: &cancellables)
    }
}
