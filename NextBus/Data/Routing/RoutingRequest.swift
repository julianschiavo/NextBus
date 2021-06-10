//
//  RoutingRequest.swift
//  NextBus
//
//  Created by Julian Schiavo on 27/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
import MapKit

struct RoutingRequest: Encodable, Hashable {
    let origin: Waypoint
    let destination: Waypoint
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HHmm"
        return formatter
    }
    
    func encode(to encoder: Encoder) throws {
        let language = LocalizedText.directionsLanguageCode
        let currentDate = Date()
        let requestDay = dateFormatter.string(from: currentDate)
        let requestTime = timeFormatter.string(from: currentDate)
        
        let param = _Param(
            language: language,
            originName: origin.name,
            originLatitude: origin.latitude,
            originLongitude: origin.longitude,
            destinationName: destination.name,
            destinationLatitude: destination.latitude,
            destinationLongitude: destination.longitude,
            requestDay: requestDay,
            requestTime: requestTime
        )
        let request = _Request(param: param)
        try request.encode(to: encoder)
    }
}

private struct _Request: Encodable {
    let api = "getRouteSearchResult4"
    let param: _Param
}

private struct _Param: Encodable {
    let language: String
    var originName: String?
    let originRadius = 300
    var originLatitude: Double?
    var originLongitude: Double?
    var destinationName: String?
    let destinationRadius = 300
    var destinationLatitude: Double?
    var destinationLongitude: Double?
    let requestDay: String
    let requestTime: String
    let elderlyMode = Null()
    let walkingRouteMode: String = "Q"
    
    enum CodingKeys: String, CodingKey {
        case language = "lang"
        case originName = "oname"
        case originRadius = "oradius"
        case originLatitude = "olat"
        case originLongitude = "olng"
        case destinationName = "dname"
        case destinationRadius = "dradius"
        case destinationLatitude = "dlat"
        case destinationLongitude = "dlng"
        case requestDay = "searchDay"
        case requestTime = "searchTime"
        case elderlyMode = "elderly"
        case walkingRouteMode
    }
}

private class Null: Codable, Hashable {
    public static func == (lhs: Null, rhs: Null) -> Bool {
        return true
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(Null.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Incorrect Type"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
}
