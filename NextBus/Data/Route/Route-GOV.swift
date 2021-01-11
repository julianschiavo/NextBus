//
//  Route-GOV.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Route {
    static func from(_ route: GOV.RawRoute) -> [Route] {
        let name = LocalizedText(en: route.nameEN,
                                 sc: route.nameSC,
                                 tc: route.nameTC)
        let origin = LocalizedText(en: route.originEN.replacingOccurrences(of: "</br>", with: "").capitalized,
                                   sc: route.originSC,
                                   tc: route.originTC)
        let destination = LocalizedText(en: route.destinationEN.replacingOccurrences(of: "</br>", with: "").capitalized,
                                        sc: route.destinationSC,
                                        tc: route.destinationTC)
        
        let inbound = Route(
            _id: String(route.id),
            companyID: route.companyID,
            name: name,
            category: route.category,
            servicePeriod: route.servicePeriod,
            direction: .inbound,
            fare: Double(route.fare) ?? 0,
            origin: origin,
            destination: destination,
            lastUpdated: Date()
        )
        
        var outbound = inbound
        outbound.direction = .inbound
        let iDestination = outbound.origin
        outbound.origin = outbound.destination
        outbound.destination = iDestination
        
        return [outbound, inbound]
    }
}

extension GOV {
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
        
        var route: [Route] {
            Route.from(self)
        }
        
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
}
