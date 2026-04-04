//
//  RootView.swift
//  ARQExchange
//
//  Created by Justin Lee on 3/25/26.
//

import Calculator
import DependencyContainer
import SwiftUI

struct RootView: View {
    @Bindable var coordinator: RootCoordinator
    
    var body: some View {
        ExchangeView(viewModel: coordinator.exchangeViewModel)
    }
}

#Preview {
    RootView(coordinator: RootCoordinator(dependencyContainer: MockDependencyContainer()))
}
