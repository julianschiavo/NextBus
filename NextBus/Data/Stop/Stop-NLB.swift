//
//  NLB-Stop.swift
//  NextBus
//
//  Created by Julian Schiavo on 21/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Stop {
    static func from(_ stop: NLB._Stop, index: Int) -> Stop {
        let name = LocalizedText(en: stop.nameEN,
                                 sc: stop.nameSC,
                                 tc: stop.nameTC)
        
        return Stop(
            id: stop.id,
            index: index,
            name: name,
            latitude: stop.latitude,
            longitude: stop.longitude,
            lastUpdated: Date()
        )
    }
}

extension NLB {
    struct RawStop: Codable {
        var data: [_Stop]
        
        enum CodingKeys: String, CodingKey {
            case data = "stops"
        }
        
        var stops: [Stop] {
            data.enumerated().map { Stop.from($0.element, index: $0.offset + 1) }
        }
    }

    struct _Stop: Codable, Hashable {
        var id: String
        
        var nameEN: String
        var nameSC: String
        var nameTC: String
        
        var fare: String
        var holidayFare: String
        
        var specialDeparturesOnlyInt: Int
        var specialDeparturesOnly: Bool { Bool(exactly: specialDeparturesOnlyInt as NSNumber) ?? false }
        
        var latitudeString: String
        var latitude: Double { Double(latitudeString) ?? 0 }
        var longitudeString: String
        var longitude: Double { Double(longitudeString) ?? 0 }
        
        enum CodingKeys: String, CodingKey {
            case id = "stopId"
            case nameEN = "stopName_e"
            case nameSC = "stopName_s"
            case nameTC = "stopName_c"
            case fare = "fare"
            case holidayFare = "fareHoliday"
            case specialDeparturesOnlyInt = "someDepartureObserveOnly"
            case latitudeString = "latitude"
            case longitudeString = "longitude"
        }
    }
}
