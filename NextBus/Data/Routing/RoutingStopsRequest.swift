//
//  RoutingStopsRequest.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

struct RoutingStopsRequest: Encodable, Hashable {
    let routing: Routing
    
    func encode(to encoder: Encoder) throws {
        let language = LocalizedText.directionsLanguageCode
        
        var origin: Waypoint
        var destination: Waypoint
        if let track = routing.tracks.first {
            origin = track.origin
            destination = track.destination
        } else {
            origin = Waypoint(id: "", index: 0, name: "", latitude: 0, longitude: 0)
            destination = Waypoint(id: "", index: 0, name: "", latitude: 0, longitude: 0)
        }
        
        let boardingLocations = routing.tracks.map { track in
            _Location(latitude: track.origin.latitude, longitude: track.origin.longitude)
        }
        let disembarkingLocations = routing.tracks.map { track in
            _Location(latitude: track.destination.latitude, longitude: track.destination.latitude)
        }
        let tracks = routing.tracks.map { track in
            _Routing(
                company: track.company?.name ?? "",
                companyName: track.company?.name ?? "",
                id: Int(track.id),
                index: track.index,
                name: track.name,
                type: track.data.type,
                originID: Int(track.origin.id),
                originName: track.origin.name,
                originIndex: track.origin.index,
                destinationID: Int(track.destination.id),
                destinationName: track.destination.name,
                destinationIndex: track.destination.index,
                elderlyPaymentMode: track.data.elderlyPaymentMode,
                fareRemark: track.data.fareRemark,
                specialType: track.data.specialType
            )
        }
        
        let param = _Param(
            language: language,
            originName: origin.name,
            originLatitude: origin.latitude,
            originLongitude: origin.longitude,
            destinationName: destination.name,
            destinationLatitude: destination.latitude,
            destinationLongitude: destination.longitude,
            price: routing.price,
            travelTime: routing.travelTime,
            boardingLocations: boardingLocations,
            disembarkingLocations: disembarkingLocations,
            tracks: tracks
        )
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
    let company: String?
    let companyName: String?
    
    let id: Int?
    let index: Int
    
    let name: String
    let type: Int
    
    let originID: Int?
    let originName: String
    let originIndex: Int
    let originMTRID = 0
    
    let destinationID: Int?
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
