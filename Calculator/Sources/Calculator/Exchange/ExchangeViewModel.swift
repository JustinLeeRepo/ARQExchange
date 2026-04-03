//
//  ExchangeViewModel.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import SwiftUI

enum BuySellSwapEvent {
    case sell
    case buy
}

//TODO: add passthrough subject that emits event for foreign currency selection
//      - should fetch rate and update header with selected currency rate and title
//      - should update foreign currency row with selected currency
//TODO: add passthroughsubject that emits event for swap button
//      - should update order of rows
//      - should update header with buy (bid) / sell (ask) rate
@Observable
public class ExchangeViewModel {
    let headerViewModel: ExchangeHeaderViewModel
    let inputViewModel: ExchangeInputViewModel
    
    var isShowingSheet: Bool = false
    
    let foreignCurrencySelectionPublisher: AnyPublisher<Currency, Never>
    let buySellSwapPublisher: AnyPublisher<BuySellSwapEvent, Never>
    var cancellables = Set<AnyCancellable>()
    
    public init() {
        let foreignCurrencySelectionEvent: PassthroughSubject<Currency, Never> = .init()
        let buySellSwapEvent: PassthroughSubject<BuySellSwapEvent, Never> = .init()
        
        let buySellSwapEventPublisher = buySellSwapEvent.eraseToAnyPublisher()
        let foreignCurrencySelectionPublisher = foreignCurrencySelectionEvent.eraseToAnyPublisher()
        
        buySellSwapPublisher = buySellSwapEventPublisher
        self.foreignCurrencySelectionPublisher = foreignCurrencySelectionPublisher
        
        self.headerViewModel = ExchangeHeaderViewModel(buySellSwapEventPublisher: buySellSwapEventPublisher, foreignCurrencySelectionPublisher: foreignCurrencySelectionPublisher)
        self.inputViewModel = ExchangeInputViewModel(buySellSwapEventSubject: buySellSwapEvent, foreignCurrencySelectionSubject: foreignCurrencySelectionEvent)
        
        setupListener()
    }
    
    private func setupListener() {
        //fetch buy or sell rate using service
        buySellSwapPublisher.sink { event in
            switch event {
            case .buy:
                
                break
            case .sell:
                
                break
            }
        }
        .store(in: &cancellables)
        
        //fetch rate for new currency using service
        foreignCurrencySelectionPublisher.sink { event in
            switch event {
            case .ars:
                break
            case .brl:
                break
            case .cop:
                break
            case .mxn:
                break
            default:
                //newly added currency to service
                break
            }
        }
        .store(in: &cancellables)
    }
}
