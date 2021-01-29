//
//  Aligned.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

extension View {
    func aligned(to alignment: Alignment, padding: CGFloat = 0) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .padding(padding)
    }
    
    func alignedHorizontally(to alignment: HorizontalAlignment, padding: CGFloat = 0) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment.normalized)
            .padding(padding)
    }
    
    func alignedVertically(to alignment: VerticalAlignment, padding: CGFloat = 0) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment.normalized)
            .padding(padding)
    }
}

private extension HorizontalAlignment {
    var normalized: Alignment {
        switch self {
        case .center: return .center
        case .leading: return .leading
        case .trailing: return .trailing
        default: return .center
        }
    }
}

private extension VerticalAlignment {
    var normalized: Alignment {
        switch self {
        case .bottom: return .bottom
        case .center, .firstTextBaseline, .lastTextBaseline: return .center
        case .top: return .top
        default: return .center
        }
    }
}
