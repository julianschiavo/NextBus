//
//  NLB-Stop.swift
//  NextBus
//
//  Created by Julian Schiavo on 21/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

struct NLBRawStop: Codable {
    var rawStops: [NLBStop]
    
    enum CodingKeys: String, CodingKey {
        case rawStops = "stops"
    }
    
    var stops: OrderedSet<Stop> {
        OrderedSet(rawStops.map { Stop(id: $0.id, generated: Date(), englishName: $0.englishName, simplifiedChineseName: $0.simplifiedChineseName, traditionalChineseName: $0.traditionalChineseName, normalFare: $0.normalFare, holidayFare: $0.holidayFare, specialDeparturesOnly: $0.specialDeparturesOnly, latitude: $0.latitude, longitude: $0.longitude) })
    }
}

struct NLBStop: Codable, Hashable {
    var id: String
    
    var englishName: String
    var simplifiedChineseName: String
    var traditionalChineseName: String
    
    var normalFare: String
    var holidayFare: String
    
    var specialDeparturesOnlyInt: Int
    var specialDeparturesOnly: Bool { Bool(exactly: specialDeparturesOnlyInt as NSNumber) ?? false }
    
    var latitudeString: String
    var latitude: Double { Double(latitudeString) ?? 0 }
    var longitudeString: String
    var longitude: Double { Double(longitudeString) ?? 0 }
    
    enum CodingKeys: String, CodingKey {
        case id = "stopId"
        case englishName = "stopName_e"
        case simplifiedChineseName = "stopName_s"
        case traditionalChineseName = "stopName_c"
        case normalFare = "fare"
        case holidayFare = "fareHoliday"
        case specialDeparturesOnlyInt = "someDepartureObserveOnly"
        case latitudeString = "latitude"
        case longitudeString = "longitude"
    }
}
