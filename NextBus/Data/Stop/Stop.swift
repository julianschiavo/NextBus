//
//  Stop.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation
import Intents

struct Stop: Codable, Hashable, Identifiable, Reorderable {
    var id: String
    var index: Int
    
    var name: LocalizedText
    var localizedName: String {
        name.current
    }
    
    var latitude: Double?
    var longitude: Double?
    
    var lastUpdated: Date
    
    // MARK: - Intent
    
    var intent: INStop {
        let intent = INStop(identifier: id, display: localizedName)
        intent.index = NSNumber(integerLiteral: index)
        intent.name = localizedName
        if let latitude = latitude {
            intent.latitude = latitude as NSNumber
        }
        if let longitude = longitude {
            intent.longitude = longitude as NSNumber
        }
        return intent
    }
    
    static func from(_ intent: INStop) -> Self? {
        guard let id = intent.identifier,
              let name = intent.name,
              let nsIndex = intent.index,
              let index = Int(exactly: nsIndex)
        else { return nil }
        
        var stop = Stop(id: id, index: index, name: LocalizedText(name), latitude: nil, longitude: nil, lastUpdated: Date())
        if let nsLatitude = intent.latitude,
           let latitude = Double(exactly: nsLatitude) {
            stop.latitude = latitude
        }
        if let nsLongitude = intent.longitude,
           let longitude = Double(exactly: nsLongitude) {
            stop.longitude = longitude
        }
        return stop
    }
}
