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
    
    @State private var companyID: CompanyID?
    @State private var routeID: String?
    @State private var stopID: String?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                view
                    .navigationTitle("Next Bus")
            }
            .environmentObject(store)
            .navigationViewStyle(StackNavigationViewStyle())
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                handleInvocation(userActivity: userActivity)
            }
        }
    }
    
    @ViewBuilder private var view: some View {
        if let companyID = companyID, let routeID = routeID {
            InvocatedExperience(companyID: companyID, routeID: routeID, stopID: stopID)
        } else {
            RoutesList()
        }
    }
    
    private func handleInvocation(userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL,
              let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let path = components.path?.split(separator: "/"),
              let companyIDString = path[safe: 0]?.uppercased(),
              let companyID = CompanyID(rawValue: String(companyIDString)),
              let routeID = path[safe: 1]
        else { return }
        
        DispatchQueue.main.async {
            self.companyID = companyID
            self.routeID = String(routeID)
            if let stopID = path[safe: 2] {
                self.stopID = String(stopID)
            }
        }
    }
}
