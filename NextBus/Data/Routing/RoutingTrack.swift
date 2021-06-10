//
//  RoutingTrack.swift
//  NextBus
//
//  Created by Julian Schiavo on 29/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

struct RoutingTrack: Equatable, Hashable, Identifiable {
    struct Data: Codable, Equatable, Hashable {
        let type: Int
        let mode: Int
        let elderlyPaymentMode: Int
        let fareRemark: String
        let specialType: Int
    }
    
    let company: Company?
    
    let id: String
    var index: Int
    
    let name: String
    
    let origin: Waypoint
    let destination: Waypoint
    var stops = [RoutingStop]()
    let isWalking: Bool
    
    let data: Data
    
    static func between(_ origin: Waypoint, and destination: Waypoint, index: Int) -> RoutingTrack {
        RoutingTrack(
            company: .unknown,
            id: UUID().uuidString,
            index: index,
            name: "Walk",
            origin: origin,
            destination: destination,
            stops: [],
            isWalking: true,
            data: Data(type: 0, mode: 0, elderlyPaymentMode: 0, fareRemark: "", specialType: 0)
        )
    }
}

private extension RoutingTrack {
    static func from(_ track: RawRoutingTrack) -> RoutingTrack {
        let company = Company(rawValue: track.company)
        let origin = Waypoint(
            id: String(track.originID),
            index: track.originIndex,
            name: String(track.originName.capitalized.split(separator: "/").first ?? Substring(track.originName.capitalized)),
            latitude: track.originLatitude,
            longitude: track.originLongitude
        )
        let destination = Waypoint(
            id: String(track.destinationID),
            index: track.destinationIndex,
            name: String(track.destinationName.capitalized.split(separator: "/").first ?? Substring(track.destinationName.capitalized)),
            latitude: track.destinationLatitude,
            longitude: track.destinationLongitude
        )
        let data = Data(
            type: track.type,
            mode: track.mode,
            elderlyPaymentMode: track.elderlyPaymentMode,
            fareRemark: track.fareRemark,
            specialType: track.specialType
        )
        return RoutingTrack(
            company: company,
            id: String(track.id),
            index: track.index,
            name: track.name,
            origin: origin,
            destination: destination,
            stops: [],
            isWalking: false,
            data: data
        )
    }
}

struct RawRoutingTrack: Codable, Equatable, Hashable, Identifiable {
    let company: String
    let companyName: String
    
    let id: Int
    let index: Int
    
    let name: String
    let type: Int
    let mode: Int
    
    let originID: Int
    let originName: String
    let originIndex: Int
    let originLatitude: Double
    let originLongitude: Double
    
    let destinationID: Int
    let destinationName: String
    let destinationIndex: Int
    let destinationLatitude: Double
    let destinationLongitude: Double
    
    var stops = [RoutingStop]()
    
    let elderlyPaymentMode: Int
    let fareRemark: String
    let specialType: Int
    
    let url: String?
    
    var track: RoutingTrack {
        RoutingTrack.from(self)
    }
    
    enum CodingKeys: String, CodingKey {
        case company = "COMPANY_CODE"
        case companyName = "COMPANY_NAME"
        case id = "ROUTE_ID"
        case index = "ROUTE_SEQ"
        case name = "ROUTE_NM"
        case type = "ROUTE_TYPE"
        case mode = "ROUTE_MODE"
        case originID = "FR_STOP_ID"
        case originName = "FR_NM"
        case originIndex = "FR_STOP_SEQ"
        case originLatitude = "FR_Y"
        case originLongitude = "FR_X"
        case destinationID = "TO_STOP_ID"
        case destinationName = "TO_NM"
        case destinationIndex = "TO_STOP_SEQ"
        case destinationLatitude = "TO_Y"
        case destinationLongitude = "TO_X"
        case elderlyPaymentMode = "PAYMENT_METHOD"
        case fareRemark = "FARE_REMARK"
        case specialType = "SPECIAL_TYPE"
        case url = "HYPERLINK"
    }
}
