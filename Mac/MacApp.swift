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
    @StateObject private var store = Store()
    
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
            .sheet(item: $experience) { _ in
                NavigationView {
                    switch experience {
                    case let .status(status):
                        InvocatedStatusExperience(experience: status)
                    default:
                        EmptyView()
                    }
                }
            }
            .onContinueUserActivity(CSSearchableItemActionType) { userActivity in
                guard let urlString = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
                      let url = URL(string: urlString) else { return }
                handleInvocation(url: url)
            }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                guard let url = userActivity.webpageURL else { return }
                handleInvocation(url: url)
            }
            .onOpenURL { url in
                handleInvocation(url: url)
            }
        }
    }
    
    private func handleInvocation(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let method = components.path.split(separator: "/").first else { return }
        
        var experience: Experience?
        switch method {
        case "status":
            experience = createStatusExperience(components: components)
        default:
            experience = nil
        }
        
        DispatchQueue.main.async {
            self.experience = experience
        }
    }
    
    private func createStatusExperience(components: URLComponents) -> Experience? {
        guard let queryItems = components.queryItems,
              let companyItem = queryItems[safe: 0]?.value,
              let company = Company(rawValue: companyItem),
              let routeID = queryItems[safe: 1]?.value else { return nil }
        
        let stopID = queryItems[safe: 2]?.value
        let status = StatusExperience(company: company, routeID: routeID, stopID: stopID)
        return .status(status)
    }
}
