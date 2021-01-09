//
//  Route.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation
import Intents

struct Route: Identifiable, Hashable, Codable {
    var id: String
    var companyID: CompanyID
    
    var name: LocalizedText
    var localizedName: String {
        name.current
    }
    
    var category: Category
    var servicePeriod: ServicePeriod
    var direction: Direction
    
    var fare: Double
    
    var origin: LocalizedText
    var localizedOrigin: String {
        origin.current
    }
    
    var destination: LocalizedText
    var localizedDestination: String {
        destination.current
    }
    
    var lastUpdated: String
    
    static func from(_ route: RawRoute) -> Route {
        let name = LocalizedText(en: route.nameEN, sc: route.nameSC, tc: route.nameTC)
        let origin = LocalizedText(en: route.originEN, sc: route.originSC, tc: route.originTC)
        let destination = LocalizedText(en: route.destinationEN, sc: route.destinationSC, tc: route.destinationTC)
        
        return Route(
            id: String(route.id),
            companyID: route.companyID,
            name: name,
            category: route.category,
            servicePeriod: route.servicePeriod,
            direction: .single,
            fare: Double(route.fare) ?? 0,
            origin: origin,
            destination: destination,
            lastUpdated: route.lastUpdated
        )
    }
}

struct RawRoute: Codable, Hashable, Identifiable {
    var id: Int
    var companyID: CompanyID
    
    var nameEN: String
    var nameSC: String
    var nameTC: String
    
    var category: Category
    var servicePeriod: ServicePeriod
    
    var fare: String
    
    var originEN: String
    var originSC: String
    var originTC: String
    
    var destinationEN: String
    var destinationSC: String
    var destinationTC: String
    
    var lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ROUTE_ID"
        case companyID = "COMPANY_CODE"
        case nameEN = "ROUTE_NAMEE"
        case nameSC = "ROUTE_NAMES"
        case nameTC = "ROUTE_NAMEC"
        case category = "ROUTE_TYPE"
        case servicePeriod = "SERVICE_MODE"
        case fare = "FULL_FARE"
        case originEN = "LOC_START_NAMEE"
        case originSC = "LOC_START_NAMES"
        case originTC = "LOC_START_NAMEC"
        case destinationEN = "LOC_END_NAMEE"
        case destinationSC = "LOC_END_NAMES"
        case destinationTC = "LOC_END_NAMEC"
        case lastUpdated = "LAST_UPDATE_DATE"
    }
}
