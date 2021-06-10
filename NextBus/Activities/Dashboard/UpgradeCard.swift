//
//  UpgradeCard.swift
//  NextBus
//
//  Created by Julian Schiavo on 16/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct UpgradeCard: View {
    @AppStorage("UpgradeCardDismissed") private var wasDismissed = false
    @Binding var sheet: Sheet?
    
    @StateObject private var payBuddy = PayBuddy()
    
    var body: some View {
        if !payBuddy.hasPlus, !wasDismissed {
            Card {
                Button {
                    sheet = .upgrade
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text(Localizable.Upgrade.suggestedTitle)
                            Text(Localizable.Upgrade.suggestedDescription)
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    } icon: {
                        Image(systemName: "plus.app")
                    }
                    .font(.largeHeadline, weight: .bold)
                    .alignedHorizontally(to: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .padding(.trailing, 20)
                    .background(Color.secondaryBackground)
                }
                .macCustomButton()
            }
            .overlay(
                Button {
                    wasDismissed = true
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline, weight: .bold)
                        .foregroundColor(.secondary)
                        .padding(10)
                }
                .alignedHorizontally(to: .trailing)
                .macCustomButton()
            )
        }
    }
}
