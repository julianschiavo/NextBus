//
//  Stop.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation
import Intents

struct Stop: Codable, Hashable, Identifiable {
    var id: String
    var index: Int
    
    var name: LocalizedText
    var localizedName: String {
        name.current
    }
    
    var latitude: Double?
    var longitude: Double?
    
    var lastUpdated: Date
    
    static func from(_ stop: RawStop) -> Stop {
        let name = LocalizedText(en: stop.nameEN, sc: stop.nameSC, tc: stop.nameTC)
        return Stop(
            id: String(stop.id),
            index: stop.index,
            name: name,
            lastUpdated: Date()
        )
    }
    
    // MARK: - Intents
    
//    static func from(intentObject: INStop) -> Stop? {
//        guard let identifier = intentObject.identifier,
//            let name = intentObject.name,
//            let indexNSNumber = intentObject.index,
//            let index = Int(exactly: indexNSNumber),
//            let specialDeparturesOnlyNSNumber = intentObject.specialDeparturesOnly,
//            let specialDeparturesOnly = Bool(exactly: specialDeparturesOnlyNSNumber),
//            let latitudeNSNumber = intentObject.latitude,
//            let latitude = Double(exactly: latitudeNSNumber),
//            let longitudeNSNumber = intentObject.longitude,
//            let longitude = Double(exactly: longitudeNSNumber) else { return nil }
//        return Stop(id: identifier, index: index, generated: Date(), englishName: name, simplifiedChineseName: name, traditionalChineseName: name, normalFare: intentObject.normalFare, holidayFare: intentObject.holidayFare, specialDeparturesOnly: specialDeparturesOnly, latitude: latitude, longitude: longitude)
//    }
//    
//    var intentObject: INStop {
//        let object = INStop(identifier: id, display: name)
//        object.index = (index ?? 0) as NSNumber
//        object.name = name
//        object.normalFare = normalFare
//        object.holidayFare = holidayFare
//        object.specialDeparturesOnly = NSNumber(value: specialDeparturesOnly)
//        object.latitude = latitude as NSNumber
//        object.longitude = longitude as NSNumber
//        return object
//    }
}

struct RawStop: Codable, Hashable, Identifiable {
    var id: Int
    var routeID: Int
    
    var direction: Int
    var index: Int
    
    var nameEN: String
    var nameSC: String
    var nameTC: String
    
    var lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case id = "STOP_ID"
        case routeID = "ROUTE_ID"
        case direction = "ROUTE_SEQ"
        case index = "STOP_SEQ"
        case nameEN = "STOP_NAMEE"
        case nameSC = "STOP_NAMES"
        case nameTC = "STOP_NAMEC"
        case lastUpdated = "LAST_UPDATE_DATE"
    }
}
