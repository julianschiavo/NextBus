//
//  Layers.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Layers<Content: View>: View {
    
    private var content: Content
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                content
            }
            .background(Color.background)
            .cornerRadius(14, on: [.bottomLeft, .bottomRight])
            .padding(.horizontal, 10)
            .padding(.top, 5)
            .padding(.bottom, 15)
            
        }
        .background(Color.background)
    }
}
