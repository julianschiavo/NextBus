//
//  RoutingTrack.swift
//  NextBus
//
//  Created by Julian Schiavo on 29/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

struct RoutingTrack: Codable, Equatable, Hashable, Identifiable {
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
