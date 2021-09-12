//
//  MacApp.swift
//  Mac
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import CoreSpotlight
import SwiftUI
import Purchases

@main
struct MacApp: App {
    @ObservedObject private var store = Store.shared
    
    @State private var experience: Experience?
    
    init() {
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "bKFVCyRdhomurfBWXgxdRbZOsjkkGjlF", appUserID: nil, observerMode: false, userDefaults: .shared)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar()
                    .navigationTitle(Localizable.appName)
            }
            .environmentObject(store)
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
