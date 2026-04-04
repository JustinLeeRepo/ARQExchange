//
//  ARQExchangeApp.swift
//  ARQExchange
//
//  Created by Justin Lee on 3/25/26.
//

import DependencyContainer
import SwiftUI

@main
struct ARQExchangeApp: App {
    @State var coordinator: RootCoordinator = .init(dependencyContainer: DependencyContainer.shared)
    var body: some Scene {
        WindowGroup {
            RootView(coordinator: coordinator)
        }
    }
}
