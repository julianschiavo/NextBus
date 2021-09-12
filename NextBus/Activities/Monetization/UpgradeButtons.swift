//
//  UpgradeButtons.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Purchases
import SwiftUI

struct UpgradeButtons: View {
    @ObservedObject var payBuddy: PayBuddy
    
    var body: some View {
        VStack(spacing: 12) {
            placeholder
            options
            RestorePurchasesButton(restore: payBuddy.restorePurchases)
        }
    }
    
    @ViewBuilder private var options: some View {
        if let packages = payBuddy.packages {
            HStack {
                ForEach(packages) { package in
                    UpgradeButton(
                        name: package.product.localizedTitle,
                        price: package.localizedPriceString
                    )
                    {
                        Task {
                            await payBuddy.purchase(package)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder private var placeholder: some View {
        if payBuddy.packages == nil {
            ProgressView()
        }
    }
}
