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
    @FocusState private var focus: Bool
    
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
            
            TextField("0", value: viewModel.amount, format: .currency(code: viewModel.currencyCode))
                .focused($focus)
                .onReceive(viewModel.focusDismissPublisher) {
                    focus = false
                }
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
        var value: Double? = 0.0
        let binding = Binding {
            value
        } set: { newValue in
            value = newValue
        }

        let usdVM = ExchangeInputRowViewModel(currency: .usd, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher(), binding: binding, focusDismissPublisher: PassthroughSubject().eraseToAnyPublisher())
//        let brlVM = ExchangeInputRowViewModel(currency: .brl, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher(), binding: binding)
//        let copVM = ExchangeInputRowViewModel(currency: .cop, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher(), binding: binding)
//        let arsVM = ExchangeInputRowViewModel(currency: .ars, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher(), binding: binding)
//        let mxnVM = ExchangeInputRowViewModel(currency: .mxn, buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher(), binding: binding)
        
        ExchangeInputRowView(viewModel: usdVM)
//        ExchangeInputRowView(viewModel: brlVM)
//        ExchangeInputRowView(viewModel: mxnVM)
//        ExchangeInputRowView(viewModel: copVM)
//        ExchangeInputRowView(viewModel: arsVM)
    }
}
