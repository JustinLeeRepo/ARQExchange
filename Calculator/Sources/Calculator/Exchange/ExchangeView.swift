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
            
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .padding()
                    .font(.caption)
                    .foregroundStyle(.pink)
                    .opacity(viewModel.error == nil ? 0 : 1)
            }
        }
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
        .padding(.top, 44)
        .background(.ultraThickMaterial)
        .sheet(isPresented: $viewModel.isCurrencySheetOpen) {
            CurrencyListView(viewModel: viewModel.currencyListViewModel)
        }
        .task {
            await viewModel.fetchExchangeInfo()
        }
        .onTapGesture {
            viewModel.dismissFocus()
        }
    }
}

#Preview {
    ExchangeView(viewModel: ExchangeViewModel(dependencyContainer: MockDependencyContainer()))
}
