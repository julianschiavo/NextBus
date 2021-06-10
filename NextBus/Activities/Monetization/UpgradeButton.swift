//
//  UpgradeButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Purchases
import SwiftUI

struct UpgradeButton: View {
    let name: String
    let price: String
    let buy: () -> Void
    
    var body: some View {
        Button(action: buy) {
            VStack(spacing: 4) {
                Text(name)
                    .font(.headline, weight: .bold)
                    .foregroundColor(.primary)
                Text(price)
                    .foregroundColor(Color.primary.opacity(0.8))
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Color.accent)
            .cornerRadius(14)
        }
        .macCustomButton()
    }
}
