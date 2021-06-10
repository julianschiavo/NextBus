//
//  UpgradeSheet.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct UpgradeSheet: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var payBuddy = PayBuddy()
    
    var body: some View {
        iOSNavigationView {
            VStack(spacing: 18) {
                title
                UpgradeList()
                Spacer()
                UpgradeButtons(payBuddy: payBuddy)
            }
            .alert(errorBinding: $payBuddy.error)
            .padding()
            .navigationTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button(Localizable.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .macMinFrame(width: 400, height: 400)
        .onChange(of: payBuddy.hasPlus) { hasPlus in
            if hasPlus {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var title: some View {
        (Text(Localizable.Upgrade.titlePrefix + "\n") + Text(Localizable.Upgrade.productName).foregroundColor(.accent))
            .font(.largerTitle, weight: .heavy)
            .alignedHorizontally(to: .leading)
    }
}
