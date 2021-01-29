//
//  DirectionsStopsRequest.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

struct DirectionsStopsRequest: Encodable, Hashable {
    let directions: Routing
    
    func encode(to encoder: Encoder) throws {
        let language = LocalizedText.directionsLanguageCode
        let originName = directions.tracks.first?.originName ?? ""
        let originLatitude = directions.tracks.first?.originLatitude ?? 0
        let originLongitude = directions.tracks.first?.originLongitude ?? 0
        let destinationName = directions.tracks.last?.destinationName ?? ""
        let destinationLatitude = directions.tracks.last?.destinationLatitude ?? 0
        let destinationLongitude = directions.tracks.last?.destinationLongitude ?? 0
        let boardingLocations = directions.tracks.map { r in
            _Location(latitude: r.originLatitude, longitude: r.originLongitude)
        }
        let disembarkingLocations = directions.tracks.map { r in
            _Location(latitude: r.destinationLatitude, longitude: r.destinationLongitude)
        }
        let tracks = directions.tracks.map { r in
            _Routing(company: r.company, companyName: r.companyName, id: r.id, index: r.index, name: r.name, type: r.type, originID: r.originID, originName: r.originName, originIndex: r.originIndex, destinationID: r.destinationID, destinationName: r.destinationName, destinationIndex: r.destinationIndex, elderlyPaymentMode: r.elderlyPaymentMode, fareRemark: r.fareRemark, specialType: r.specialType)
        }
        
        let param = _Param(language: language, originName: originName, originLatitude: originLatitude, originLongitude: originLongitude, destinationName: destinationName, destinationLatitude: destinationLatitude, destinationLongitude: destinationLongitude, price: directions.price, travelTime: directions.travelTime, boardingLocations: boardingLocations, disembarkingLocations: disembarkingLocations, tracks: tracks)
        let request = _Request(param: param)
        try request.encode(to: encoder)
    }
}

private struct _Request: Encodable {
    let api = "getDetailMulti6"
    let param: _Param
}

private struct _Param: Encodable {
    let language: String
    let originName: String
    let originLatitude: Double
    let originLongitude: Double
    let destinationName: String
    let destinationLatitude: Double
    let destinationLongitude: Double
    let price: Double
    let travelTime: Int
    let boardingLocations: [_Location]
    let disembarkingLocations: [_Location]
    let tracks: [_Routing]
    
    enum CodingKeys: String, CodingKey {
        case language = "lang"
        case originName = "oname"
        case originLatitude = "olat"
        case originLongitude = "olng"
        case destinationName = "dname"
        case destinationLatitude = "dlat"
        case destinationLongitude = "dlng"
        case price = "fare"
        case travelTime = "time"
        case boardingLocations = "getOnLocs"
        case disembarkingLocations = "getOffLocs"
        case tracks = "routes"
    }
}

private struct _Location: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "long"
    }
}

private struct _Routing: Codable {
    let company: String
    let companyName: String
    
    let id: Int
    let index: Int
    
    let name: String
    let type: Int
    
    let originID: Int
    let originName: String
    let originIndex: Int
    let originMTRID = 0
    
    let destinationID: Int
    let destinationName: String
    let destinationIndex: Int
    let destinationMTRID = 0
    
    let elderlyPaymentMode: Int
    let fareRemark: String
    let specialType: Int
    
    enum CodingKeys: String, CodingKey {
        case company = "comp_code"
        case companyName = "comp_name"
        case id = "route_id"
        case index = "route_seq"
        case name = "route_name"
        case type = "route_type"
        case originID = "from_stop_id"
        case originName = "from_stop_name"
        case originIndex = "from_stop_seq"
        case originMTRID = "from_mtr_stop_id"
        case destinationID = "to_stop_id"
        case destinationName = "to_stop_name"
        case destinationIndex = "to_stop_seq"
        case destinationMTRID = "to_mtr_stop_id"
        case elderlyPaymentMode = "elderly_payment_method"
        case fareRemark = "fare_remark"
        case specialType = "special_type"
    }
}
