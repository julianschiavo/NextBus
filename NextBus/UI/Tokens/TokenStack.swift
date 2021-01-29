//
//  TokenStack.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct TokenStack: View {
    let tokens: [Token]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(tokens) { token in
                    TokenBadge(token: token)
                }
            }
        }
    }
}
