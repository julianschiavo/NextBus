//
//  TokenBadge.swift
//  NextBus
//
//  Created by Julian Schiavo on 31/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct TokenBadge: View {
    let token: Token
    
    var body: some View {
        Label(token.text, systemImage: token.imageName)
            .font(Font.system(.callout, design: .rounded).weight(.medium))
            .padding(6)
            .background(token.color)
            .cornerRadius(6)
    }
}
