//
//  SpotlightBuddy.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

#if !os(watchOS)
import CoreSpotlight
#endif
import Foundation

class SpotlightBuddy {
    func index(routes: [Route]) {
        #if !os(watchOS)
        let items = routes.compactMap(item)
        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("\(items.count) Search items successfully indexed!")
            }
        }
        #endif
    }
    
    #if !os(watchOS)
    private func item(for route: Route) -> CSSearchableItem? {
        guard let url = StatusExperience(company: route.company, routeID: route.id, stopID: nil).toURL() else { return nil }
        let attributeSet = CSSearchableItemAttributeSet(contentType: .item)
        attributeSet.title = route.localizedName
        attributeSet.contentDescription = route.localizedName + " to " + route.localizedDestination
        attributeSet.supportsNavigation = true
        return CSSearchableItem(uniqueIdentifier: url.absoluteString, domainIdentifier: "com.julianschiavo.nextbus.route", attributeSet: attributeSet)
    }
    #endif
    
    // MARK: - Singleton
    
    static let shared = SpotlightBuddy()
    
    private init() {
        
    }
}
