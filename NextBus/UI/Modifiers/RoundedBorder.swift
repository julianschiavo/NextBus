//
//  RoundedBorder.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

extension View {
    func roundedBorder(_ radius: CGFloat) -> some View {
        let modifier = RoundedBorder(radius: radius)
        return ModifiedContent(content: self, modifier: modifier)
    }
}

struct RoundedBorder: ViewModifier {
    var radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(
                RoundedRectangle(cornerRadius: radius)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color.separator, lineWidth: 1)
            )
    }
}
