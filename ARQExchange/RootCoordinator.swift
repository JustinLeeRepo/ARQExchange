//
//  RootCoordinator.swift
//  ARQExchange
//
//  Created by Justin Lee on 3/25/26.
//

import Calculator
import DependencyContainer
import SwiftUI

@Observable
class RootCoordinator {
    private let dependencyContainer: DependencyContainable
    var exchangeViewModel: ExchangeViewModel
    init(dependencyContainer: DependencyContainable) {
        self.dependencyContainer = dependencyContainer
        self.exchangeViewModel = ExchangeViewModel(dependencyContainer: dependencyContainer)
    }
}
