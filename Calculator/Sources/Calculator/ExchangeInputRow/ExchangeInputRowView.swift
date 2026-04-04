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
            
            TextField(value: viewModel.amount, format: .currency(code: viewModel.currencyCode)) {}
                .keyboardType(.decimalPad)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
                .padding(.trailing)
        }
        .background(.background)
        .clipShape(.rect(cornerRadius: 12.0))
        .padding(.horizontal)
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
        var value = 0.0
        let binding = Binding {
            value
        } set: { newValue in
            value = newValue
        }

        let usdVM = ExchangeInputRowViewModel(currency: .usd, amount: 9999, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher(), binding: binding)
//        let brlVM = ExchangeInputRowViewModel(currency: .brl, amount: 184075.59, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher(), binding: binding)
//        let copVM = ExchangeInputRowViewModel(currency: .cop, amount: 500000, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher())
//        let arsVM = ExchangeInputRowViewModel(currency: .ars, amount: 100000, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher())
//        let mxnVM = ExchangeInputRowViewModel(currency: .mxn, amount: 2000, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher())
        
        ExchangeInputRowView(viewModel: usdVM)
//        ExchangeInputRowView(viewModel: brlVM)
//        ExchangeInputRowView(viewModel: mxnVM)
//        ExchangeInputRowView(viewModel: copVM)
//        ExchangeInputRowView(viewModel: arsVM)
    }
}
