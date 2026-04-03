//
//  RootView.swift
//  ARQExchange
//
//  Created by Justin Lee on 3/25/26.
//

import Calculator
import SwiftUI

struct RootView: View {
    @Bindable var coordinator: RootCoordinator
    
    var body: some View {
        ExchangeView(viewModel: coordinator.exchangeViewModel)
            .sheet(isPresented: $coordinator.isSelectorShown) {
                Text("currency picker")
            }
    }
}

#Preview {
    RootView(coordinator: RootCoordinator())
}
