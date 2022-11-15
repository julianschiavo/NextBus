//
//  App.swift
//  NextBus
//
//  Created by Julian Schiavo on 13/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import CoreSpotlight
import SwiftUI
import RevenueCat

@main struct App: SwiftUI.App {
    @ObservedObject private var store = Store.shared
    
    @StateObject private var payBuddy = PayBuddy()
    @State private var experience: Experience?
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "bKFVCyRdhomurfBWXgxdRbZOsjkkGjlF", appUserID: nil, observerMode: false, userDefaults: .shared)
    }
    
    var body: some Scene {
        WindowGroup {
            Main()
                .sheet(item: $experience) { experience in
                    NavigationView {
                        switch experience {
                        case .list:
                            EmptyView()
                        case let .status(company, routeID, stopID):
                            InvocatedStatusExperience(company: company, routeID: routeID, stopID: stopID)
                        }
                    }
                }
                .navigationTitle(Localizable.appName)
                .environmentObject(store)
                .environmentObject(payBuddy)
                .onContinueUserActivity(CSSearchableItemActionType) { userActivity in
                    guard let urlString = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
                          let url = URL(string: urlString) else { return }
                    experience = Experience.for(url: url)
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    guard let url = userActivity.webpageURL else { return }
                    experience = Experience.for(url: url)
                }
                .onOpenURL { url in
                    experience = Experience.for(url: url)
                }
        }
    }
}
