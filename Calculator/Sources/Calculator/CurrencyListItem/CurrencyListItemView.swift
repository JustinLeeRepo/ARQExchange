//
//  CurrencyListItemView.swift
//  Calculator
//
//  Created by Justin Lee on 4/1/26.
//

import SwiftUI

struct CurrencyListItemView: View {
    var viewModel: CurrencyListItemViewModel
    var body: some View {
        Button {
            viewModel.selectCurrency()
        } label: {
            label
        }
        .buttonStyle(.plain)
    }
    
    private var label: some View {
        HStack {
            FlagView(viewModel: FlagViewModel(currency: viewModel.currency))
            
            Text(viewModel.title)
            
            Spacer()
            
            if viewModel.isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
            else {
                Image(systemName: "circle")
                    .foregroundStyle(.separator)
            }
        }
    }
}
