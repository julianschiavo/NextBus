//
//  App.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

@main
struct App: SwiftUI.App {
    @ObservedObject private var store = Store.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Main()
            }
            .environmentObject(store)
        }
    }
}
