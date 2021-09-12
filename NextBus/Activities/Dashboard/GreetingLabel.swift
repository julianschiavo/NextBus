//
//  GreetingLabel.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct GreetingLabel: View {
    var body: some View {
        Label(text, systemImage: iconName)
            .font(.title2, weight: .bold)
            .alignedHorizontally(to: .leading)
    }
    
    private var text: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12: return "Good Morning"
        case 13..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
    
    private var iconName: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<7: return "sunrise.fill"
        case 7..<12: return "sun.min.fill"
        case 13..<17: return "sun.dust"
        case 17..<19: return "sunset.fill"
        case 19..<22: return "moon.fill"
        default: return "moon.stars.fill"
        }
    }
}
