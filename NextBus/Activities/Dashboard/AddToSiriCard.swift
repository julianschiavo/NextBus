//
//  AddToSiriCard.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Intents
import SwiftUI

struct AddToSiriCard: View {
    @AppStorage("AddToSiriCardDismissed") private var wasDismissed = false
    
    var body: some View {
        if !wasDismissed {
            Card {
                AddToSiriButton(shortcut: INShortcut.getUpcomingBuses()) {
                    wasDismissed = true
                }
                .frame(height: 50)
                .overlay(
                    Button {
                        wasDismissed = true
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .padding(10)
                    }
                    .alignedHorizontally(to: .trailing)
                )
            }
        }
    }
}
