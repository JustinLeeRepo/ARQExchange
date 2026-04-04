//
//  ExchangeView.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import DependencyContainer
import SwiftUI

public struct ExchangeView: View {
    @Bindable var viewModel: ExchangeViewModel
    
    public init(viewModel: ExchangeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ExchangeHeaderView(viewModel: viewModel.headerViewModel)
            
            ExchangeInputView(viewModel: viewModel.inputViewModel)
            
            Spacer()
        }
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
        .padding(.top, 44)
        .background(.ultraThickMaterial)
        .sheet(isPresented: $viewModel.isCurrencySheetOpen) {
            CurrencyListView(viewModel: viewModel.currencyListViewModel)
        }
        .task {
            await viewModel.fetchCurrencies()
            await viewModel.fetchRates()
        }
    }
}

#Preview {
    ExchangeView(viewModel: ExchangeViewModel(dependencyContainer: MockDependencyContainer()))
}
