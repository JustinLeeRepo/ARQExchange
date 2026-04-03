//
//  ExchangeInputRowView.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import SwiftUI
 
struct ExchangeInputRowView: View {
    @Bindable var viewModel: ExchangeInputRowViewModel
    var body: some View {
        HStack() {
            if viewModel.isLocked {
                inputLabel
            }
            else {
                Button {
                    viewModel.openCurrencySelectionSheet()
                } label: {
                    inputLabel
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            TextField("0", value: $viewModel.amount, format: .currency(code: viewModel.currencyCode))
                .keyboardType(.decimalPad)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
                .padding(.trailing)
        }
        .background(.background)
        .clipShape(.rect(cornerRadius: 12.0))
        .padding(.horizontal)
        .sheet(isPresented: $viewModel.isCurrenncySheetOpen) {
            CurrencyListView(viewModel: viewModel.currencyListViewModel)
        }
    }
    
    private var inputLabel: some View {
        HStack(spacing: 8) {
            FlagView(viewModel: viewModel.flagViewModel)
            
            HStack(spacing: 4) {
                Text(viewModel.currencyCode)
                
                if !viewModel.isLocked {
                    Label("Select another currency", systemImage: "chevron.down")
                        .labelStyle(.iconOnly)
                }
            }
        }
        .padding()
    }
}
 
#Preview {
    VStack(spacing: 12) {
        ExchangeInputRowView(viewModel: ExchangeInputRowViewModel(currency: .usd, amount: 9999, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject()))
        
        ExchangeInputRowView(viewModel: ExchangeInputRowViewModel(currency: .brl, amount: 184065.59, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject()))
        
        ExchangeInputRowView(viewModel: ExchangeInputRowViewModel(currency: .mxn, amount: 1800, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject()))
        
        ExchangeInputRowView(viewModel: ExchangeInputRowViewModel(currency: .cop, amount: 50000, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject()))
        
        ExchangeInputRowView(viewModel: ExchangeInputRowViewModel(currency: .ars, amount: 10000, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject()))
    }
}
