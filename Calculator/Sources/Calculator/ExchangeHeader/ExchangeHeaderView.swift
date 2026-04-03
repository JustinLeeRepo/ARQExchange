//
//  ExchangeHeaderView.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import Combine
import SwiftUI

struct ExchangeHeaderView: View {
    let viewModel: ExchangeHeaderViewModel
    init(viewModel: ExchangeHeaderViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text("Exchange Calculator")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("\(viewModel.exchangeRate)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.green)
        }
        .padding()
    }
}

#Preview {
    ExchangeHeaderView(viewModel: ExchangeHeaderViewModel(buySellSwapEventPublisher: PassthroughSubject().eraseToAnyPublisher(), foreignCurrencySelectionPublisher: PassthroughSubject().eraseToAnyPublisher()))
}
