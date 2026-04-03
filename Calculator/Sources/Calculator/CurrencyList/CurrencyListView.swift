//
//  CurrencyListView.swift
//  Calculator
//
//  Created by Justin Lee on 4/1/26.
//

import Combine
import SwiftUI

struct CurrencyListView: View {
    var viewModel: CurrencyListViewModel
    
    var body: some View {
        
        header
        //TODO: switch to listItemViewModels
        List(viewModel.currencies) { currency in
            CurrencyListItemView(viewModel: viewModel.listItemViewModel(for: currency))
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium])
        .task {
            await viewModel.fetchCurrencies()
        }
    }
    
    var header: some View {
        HStack {
            Text("Choose currency")
                .font(.title)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button {
                viewModel.closeSheet()
            } label: {
                Label("Close", systemImage: "xmark")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(.plain)

        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
    }
}

#Preview {
    VStack {}
    .sheet(isPresented: Binding<Bool>(get: { true }, set: { _ in }), content: {
        CurrencyListView(viewModel: CurrencyListViewModel(selectedCurrency: .mxn, foreignCurrencySelectionSubject: PassthroughSubject()))
            .presentationDetents([.medium])
    })
}
