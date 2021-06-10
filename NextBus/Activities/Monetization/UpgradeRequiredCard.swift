//
//  UpgradeRequiredCard.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct UpgradeRequiredCard: View {
    @Binding var sheet: Sheet?
    
    var body: some View {
        Card {
            Button {
                sheet = .upgrade
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text(Localizable.Upgrade.requiredTitle)
                        Text(Localizable.Upgrade.requiredDescription)
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
                .background(Color.secondaryBackground)
            }
            .macCustomButton()
        }
    }
}
