//
//  Clip.swift
//  Clip
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

@main
struct Clip: App {
    
    @ObservedObject private var store = Store.shared
    
    @State private var experience: Experience?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RoutesList()
                    .navigationTitle(Localizable.appName)
            }
            .sheet(item: $experience) { _ in
                switch experience {
                case .list:
                    RoutesList()
                case let .status(company, routeID, stopID):
                    InvocatedStatusExperience(company: company, routeID: routeID, stopID: stopID)
                default:
                    EmptyView()
                }
            }
            .environmentObject(store)
            .navigationViewStyle(.stacks)
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
