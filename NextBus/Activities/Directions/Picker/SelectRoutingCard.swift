//
//  SelectRoutingCard.swift
//  NextBus
//
//  Created by Julian Schiavo on 29/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct SelectRoutingCard: View {
    let onClick: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack {
            selectButton
            cancelButton
        }
        .padding(10)
        .background(Color.secondaryBackground)
        .roundedBorder(20)
        .padding(8)
    }
    
    private var selectButton: some View {
        Button(action: onClick) {
            Text(Localizable.Directions.selectRouting)
                .font(.headline, weight: .bold)
                .foregroundColor(.primary)
                .padding(15)
                .frame(maxWidth: .infinity)
                .background(Color.accent)
                .cornerRadius(10)
        }
        .macCustomButton()
    }
    
    private var cancelButton: some View {
        Button(action: onCancel) {
            Text(Localizable.cancel)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.secondaryBackground)
                .cornerRadius(10)
        }
        .macCustomButton()
    }
}
