//
//  ExchangeView.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import SwiftUI

public struct ExchangeView: View {
    let viewModel: ExchangeViewModel
    
    public init(viewModel: ExchangeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ExchangeHeaderView(viewModel: viewModel.headerViewModel)
            
            ExchangeInputView(viewModel: viewModel.inputViewModel)
            
            Spacer()
        }
        .padding(.top, 44)
        .background(.ultraThickMaterial)
//        .sheet(isPresented: $viewModel.isShowingSheet) {
//            Text("YYYYEEEE")
//        }
    }
}

#Preview {
    ExchangeView(viewModel: ExchangeViewModel())
}
