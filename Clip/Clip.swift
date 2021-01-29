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
    
    @StateObject private var store = Store()
    
    @State private var experience: Experience?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RoutesList()
                    .navigationTitle("Next Bus")
            }
            .sheet(item: $experience) { _ in
                switch experience {
                case .list:
                    RoutesList()
                case let .status(status):
                    InvocatedStatusExperience(experience: status)
                default:
                    EmptyView()
                }
            }
            .environmentObject(store)
            .navigationViewStyle(StackNavigationViewStyle())
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
        
        switch method {
        case "list":
            experience = .list
        case "status":
            experience = createStatusExperience(components: components) ?? .list
        default:
            return
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
