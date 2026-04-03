//
//  RootCoordinator.swift
//  ARQExchange
//
//  Created by Justin Lee on 3/25/26.
//

import SwiftUI
import Calculator

@Observable
class RootCoordinator {
    var exchangeViewModel: ExchangeViewModel
    var isSelectorShown: Bool = false
    public init() {
        self.exchangeViewModel = ExchangeViewModel()
    }
}
