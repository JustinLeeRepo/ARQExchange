//
//  ExchangeViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import DependencyContainer
import Models
import Service
import SwiftUI

enum BuySellSwapEvent {
    case sell
    case buy
}

enum ForeignCurrencySelectionEvent {
    case selected(Currency)
    case open
    case close
}

@Observable
public class ExchangeViewModel {
    let headerViewModel: ExchangeHeaderViewModel
    let inputViewModel: ExchangeInputViewModel
    var currencyListViewModel: CurrencyListViewModel
    
    private var currencies: [Currency] = Currency.mockList
    private var selectedCurrency: Currency = Currency.mockList[0]
    private var rates: [Currency: Rate] = Rate.mockDict
    
    var isCurrencySheetOpen = false
    var isLoading = true
    var error: Error?
    
    private let focusDismissSubject = PassthroughSubject<Void, Never>()
    private let currentRateSubject: CurrentValueSubject<Rate?, Never>
    private let foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>
    private var cancellables = Set<AnyCancellable>()
    
    private let rateService: RateServicable
    private let currencyService: CurrencyServicable
    
    public init(dependencyContainer: DependencyContainable) {
        let foreignCurrencySelectionEvent: PassthroughSubject<ForeignCurrencySelectionEvent, Never> = .init()
        let foreignCurrencySelectionPublisher = foreignCurrencySelectionEvent.eraseToAnyPublisher()
        self.foreignCurrencySelectionSubject = foreignCurrencySelectionEvent

        let buySellSwapEvent: PassthroughSubject<BuySellSwapEvent, Never> = .init()
        let buySellSwapEventPublisher = buySellSwapEvent.eraseToAnyPublisher()
        
        let currentRateSubject: CurrentValueSubject<Rate?, Never> = .init(nil)
        let currentRatePublisher = currentRateSubject.eraseToAnyPublisher()
        self.currentRateSubject = currentRateSubject
        
        self.headerViewModel = ExchangeHeaderViewModel(foreignCurrency: Currency.mockSelected, buySellSwapEventPublisher: buySellSwapEventPublisher, foreignCurrencySelectionPublisher: foreignCurrencySelectionPublisher, ratePublisher: currentRatePublisher)
        self.inputViewModel = ExchangeInputViewModel(foreignCurrency: Currency.mockSelected, buySellSwapEventSubject: buySellSwapEvent, foreignCurrencySelectionSubject: foreignCurrencySelectionEvent, ratePublisher: currentRatePublisher, focusDismissPublisher: focusDismissSubject.eraseToAnyPublisher())
        self.currencyListViewModel = CurrencyListViewModel(selectedCurrency: Currency.mockSelected, foreignCurrencySelectionSubject: foreignCurrencySelectionEvent)
        
        self.rateService = dependencyContainer.getRateService()
        self.currencyService = dependencyContainer.getCurrencyService()
        
        setupListener()
    }
    
    func dismissFocus() {
        focusDismissSubject.send()
    }
    
    func fetchCurrencies() async {
        isLoading = true
        
        do {
            currencies = try await self.currencyService.fetchCurrencies()
            selectedCurrency = currencies[0]
            
            currencyListViewModel.currencies = currencies
            self.foreignCurrencySelectionSubject.send(.selected(selectedCurrency))
            print("currencies fetched \(currencies)")
        } catch {
            print("error fetching currencies \(error)")
            showError(error: error)
        }
        
        isLoading = false
    }
    
    func fetchRates() async {
        isLoading = true
        
        do {
            let rates = try await rateService.fetchRates(currency: currencies)
            self.rates = rates.reduce(into: [Currency: Rate](), { dict, rate in
                dict[rate.foreignCurrency] = rate
            })
            
            self.currentRateSubject.send(self.rates[self.selectedCurrency])
            print("rates fetched \(self.rates)")
        } catch {
            print("error fetching rates \(error)")
            showError(error: error)
        }
        
        isLoading = false
    }
    
    private func showError(error: Error) {
        withAnimation {
            self.error = error
            self.isLoading = false
            
            Task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                
                withAnimation {
                    self.error = nil
                }
            }
        }
    }
    
    private func setupListener() {
        
        //fetch rate for new currency using service
        foreignCurrencySelectionSubject.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .open:
                self.isCurrencySheetOpen = true
                break
                
            case .close:
                self.isCurrencySheetOpen = false
                break
                
            case .selected(let currency):
                self.selectedCurrency = currency
                self.currentRateSubject.send(self.rates[currency])
                self.isCurrencySheetOpen = false
            }
        }
        .store(in: &cancellables)
    }
}
