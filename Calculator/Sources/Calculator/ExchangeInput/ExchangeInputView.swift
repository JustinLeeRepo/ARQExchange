//
//  ExchangeInputView.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import SwiftUI

// MARK: - Currency Input Card

struct ExchangeInputView: View {
    var viewModel: ExchangeInputViewModel
    @Namespace private var swapNamespace
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isBuying {
                ExchangeInputRowView(viewModel: viewModel.foreignExchangeInputRowViewModel)
                    .matchedGeometryEffect(id: "foreign", in: swapNamespace)
                ExchangeInputRowView(viewModel: viewModel.usdExchangeInputRowViewModel)
                    .matchedGeometryEffect(id: "usd", in: swapNamespace)
            } else {
                ExchangeInputRowView(viewModel: viewModel.usdExchangeInputRowViewModel)
                    .matchedGeometryEffect(id: "usd", in: swapNamespace)
                ExchangeInputRowView(viewModel: viewModel.foreignExchangeInputRowViewModel)
                    .matchedGeometryEffect(id: "foreign", in: swapNamespace)
            }
        }
        .animation(.linear, value: viewModel.isBuying)
        .overlay {
            SwapButton {
//                withAnimation {
                viewModel.swapBuySell()
//                }
            }
        }
    }
}

struct SwapButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 36, height: 36)
                
                Image(systemName: "arrow.down")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
        .padding(8)
        .background(.regularMaterial)
        .clipShape(.circle)
    }
}

#Preview {
    ExchangeInputView(viewModel: ExchangeInputViewModel(foreignCurrency: .ars, buySellSwapEventSubject: PassthroughSubject(), foreignCurrencySelectionSubject: PassthroughSubject(), ratePublisher: PassthroughSubject().eraseToAnyPublisher(), focusDismissPublisher: PassthroughSubject().eraseToAnyPublisher()))
}
