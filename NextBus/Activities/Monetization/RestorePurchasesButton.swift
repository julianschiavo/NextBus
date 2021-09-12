//
//  RestorePurchasesButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RestorePurchasesButton: View {
    let restore: () async -> Void
    
    var body: some View {
        Button {
            Task {
                await restore()
            }
        } label: {
            Text(Localizable.Upgrade.restorePurchases)
                .foregroundColor(.accent)
        }
        .macCustomButton()
    }
}
