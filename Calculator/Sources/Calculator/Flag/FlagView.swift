//
//  FlagView.swift
//  Calculator
//
//  Created by Justin Lee on 3/25/26.
//

import SwiftUI

struct FlagView: View {
    let viewModel: FlagViewModel
    var body: some View {
        Text(viewModel.flagEmoji)
            .font(.largeTitle)
//            .padding()
            .background(.ultraThickMaterial)
            .clipShape(.circle)
    }
}

#Preview {
    FlagView(viewModel: FlagViewModel(currency: .cop))
}
