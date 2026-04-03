//
//  CurrencyListViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 4/1/26.
//

import Combine
import SwiftUI

//add service to fetch available currencies here
@Observable
class CurrencyListViewModel {
    var currencies = [Currency]()
    private var selectedCurrency: Currency
    private let foreignCurrencySelectionSubject: PassthroughSubject<Currency, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(selectedCurrency: Currency, foreignCurrencySelectionSubject: PassthroughSubject<Currency, Never>) {
        self.selectedCurrency = selectedCurrency
        self.foreignCurrencySelectionSubject = foreignCurrencySelectionSubject
        
        setupListener()
    }
    
    //TODO: map the fetched currencies into CurrencyListItemViewModel
    func fetchCurrencies() async {
        currencies = [.ars, .brl, .cop, .mxn]
    }
    
    func listItemViewModel(for currency: Currency) -> CurrencyListItemViewModel {
        .init(currency: currency, isSelected: selectedCurrency == currency, foreignCurrencySelectionSubject: foreignCurrencySelectionSubject)
    }
    
    func closeSheet() {
        //send currency selected with selectedCurrency
        foreignCurrencySelectionSubject.send(selectedCurrency)
    }
    
    private func setupListener() {
        foreignCurrencySelectionSubject.sink { [weak self] currency in
            guard let self = self else { return }
            self.selectedCurrency = currency
        }
        .store(in: &cancellables)
    }
}
