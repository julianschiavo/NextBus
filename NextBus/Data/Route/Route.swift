//
//  Route.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation
import Intents

struct Route: Identifiable, Hashable, Codable {
    var id: String {
        _id + direction.id
    }
    var _id: String
    var company: Company
    
    var name: LocalizedText
    var localizedName: String {
        name.current
    }
    
    var description: LocalizedText?
    var localizedDescription: String? {
        description?.current
    }
    
    var category: Category
    var servicePeriod: ServicePeriod
    var direction: Direction
    
    var fare: Double
    
    var origin: LocalizedText
    var localizedOrigin: String {
        origin.current
    }
    
    var destination: LocalizedText
    var localizedDestination: String {
        destination.current
    }
    
    var lastUpdated: Date
    
    // MARK: - Intent
    
    var intent: INRoute {
        let intent = INRoute(identifier: id, display: localizedName + " " + Localizable.to(localizedDestination))
        intent.internalID = _id
        intent.company = company.intent
        intent.name = localizedName
        intent.userDescription = localizedDescription
        intent.category = category.intent
        intent.servicePeriod = servicePeriod.intent
        intent.direction = direction.intent
        intent.fare = NSNumber(floatLiteral: fare)
        intent.origin = localizedOrigin
        intent.destination = localizedDestination
        return intent
    }
    
    static func from(_ intent: INRoute) -> Self? {
        guard let _id = intent.internalID,
              let name = intent.name,
              let nsFare = intent.fare,
              let fare = Double(exactly: nsFare),
              let origin = intent.origin,
              let destination = intent.destination
        else { return nil }
        
        var route = Route(
            _id: _id,
            company: .from(intent.company),
            name: LocalizedText(name),
            description: nil,
            category: .from(intent.category),
            servicePeriod: .from(intent.servicePeriod),
            direction: .from(intent.direction),
            fare: fare,
            origin: LocalizedText(origin),
            destination: LocalizedText(destination),
            lastUpdated: Date()
        )
        if let description = intent.userDescription {
            route.description = LocalizedText(description)
        }
        return route
    }
}
