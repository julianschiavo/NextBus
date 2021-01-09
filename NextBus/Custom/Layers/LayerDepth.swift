//
//  LayerDepth.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

enum LayerDepth {
    case top
    case primary
    case secondary
    case tertiary
    
    @ViewBuilder var backgroundColor: some View {
        switch self {
        case .top: Color.clear
        case .primary: Color.secondaryBackground
        case .secondary: Color.tertiaryBackground
        case .tertiary: Color.quaternaryBackground
        }
    }
    
    @ViewBuilder var lowerBackgroundColor: some View {
        switch self {
        case .top: Color.clear
        case .primary: Color.background
        case .secondary: Color.secondaryBackground
        case .tertiary: Color.tertiaryBackground
        }
    }
}
