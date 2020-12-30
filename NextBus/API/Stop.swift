//
//  Stop.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation
import Intents

enum Direction: String, Codable, Hashable {
    case oneWay
    case inbound
    case outbound
    
    var name: String {
        switch self {
        case .oneWay: return Localizations.oneWay
        case .inbound: return Localizations.inbound
        case .outbound: return Localizations.outbound
        }
    }
    
    func origin(for route: Route) -> String {
        switch self {
        case .inbound: return route.destination
        case .outbound, .oneWay: return route.origin
        }
    }
    
    func destination(for route: Route) -> String {
        switch self {
        case .inbound: return route.origin
        case .outbound, .oneWay: return route.destination
        }
    }
    
    // MARK: - Intents
    
    static func from(intentObject: INDirection) -> Direction {
        switch intentObject {
        case .oneWay: return .oneWay
        case .inbound: return .inbound
        case .outbound, .unknown: return .outbound
        }
    }
    
    var intentObject: INDirection {
        switch self {
        case .oneWay: return .oneWay
        case .inbound: return .inbound
        case .outbound: return .outbound
        }
    }
}

struct Stop: Codable, Hashable, Identifiable {
    var id: String
    var index: Int?
    var generated: Date
    
    var name: String {
        LocalizedText(en: englishName, sc: simplifiedChineseName, tc: traditionalChineseName).current
    }
    var englishName: String
    var simplifiedChineseName: String
    var traditionalChineseName: String
    
    // These properties only apply to NLB routes
    var normalFare: String?
    var holidayFare: String?
    var specialDeparturesOnly: Bool = false
    
    var latitude: Double
    var longitude: Double
    
    // MARK: - Intents
    
    static func from(intentObject: INStop) -> Stop? {
        guard let identifier = intentObject.identifier,
            let name = intentObject.name,
            let indexNSNumber = intentObject.index,
            let index = Int(exactly: indexNSNumber),
            let specialDeparturesOnlyNSNumber = intentObject.specialDeparturesOnly,
            let specialDeparturesOnly = Bool(exactly: specialDeparturesOnlyNSNumber),
            let latitudeNSNumber = intentObject.latitude,
            let latitude = Double(exactly: latitudeNSNumber),
            let longitudeNSNumber = intentObject.longitude,
            let longitude = Double(exactly: longitudeNSNumber) else { return nil }
        return Stop(id: identifier, index: index, generated: Date(), englishName: name, simplifiedChineseName: name, traditionalChineseName: name, normalFare: intentObject.normalFare, holidayFare: intentObject.holidayFare, specialDeparturesOnly: specialDeparturesOnly, latitude: latitude, longitude: longitude)
    }
    
    var intentObject: INStop {
        let object = INStop(identifier: id, display: name)
        object.index = (index ?? 0) as NSNumber
        object.name = name
        object.normalFare = normalFare
        object.holidayFare = holidayFare
        object.specialDeparturesOnly = NSNumber(value: specialDeparturesOnly)
        object.latitude = latitude as NSNumber
        object.longitude = longitude as NSNumber
        return object
    }
}
