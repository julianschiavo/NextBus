//
//  NLB-Route.swift
//  NextBus
//
//  Created by Julian Schiavo on 21/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

struct NLBRawRoute: Codable {
    var rawRoutes: [NLBRoute]
    
    enum CodingKeys: String, CodingKey {
        case rawRoutes = "routes"
    }
    
    var routes: OrderedSet<Route> {
        OrderedSet(rawRoutes.map { Route(companyID: .nlb, id: $0.routeID, name: $0.routeNo, isOneWay: true, isSpecial: $0.isSpecialRoute, isOvernight: $0.isOvernightRoute, generated: Date(), englishOrigin: $0.englishOrigin, simplifiedChineseOrigin: $0.simplifiedChineseOrigin, traditionalChineseOrigin: $0.traditionalChineseOrigin, englishDestination: $0.englishDestination, simplifiedChineseDestination: $0.simplifiedChineseDestination, traditionalChineseDestination: $0.traditionalChineseDestination) })
    }
}


struct NLBRoute: Hashable, Codable {
    var routeID: String
    var routeNo: String
    
    var isSpecialRouteInt: Int
    var isSpecialRoute: Bool { Bool(exactly: isSpecialRouteInt as NSNumber) ?? false }
    
    var isOvernightRouteInt: Int
    var isOvernightRoute: Bool { Bool(exactly: isOvernightRouteInt as NSNumber) ?? false }
    
    var englishRouteName: String
    var simplifiedChineseRouteName: String
    var traditionalChineseRouteName: String
    
    var englishOrigin: String {
        englishRouteName.components(separatedBy: " > ").first ?? englishRouteName
    }
    var simplifiedChineseOrigin: String {
        simplifiedChineseRouteName.components(separatedBy: " > ").first ?? simplifiedChineseRouteName
    }
    var traditionalChineseOrigin: String {
        traditionalChineseRouteName.components(separatedBy: " > ").first ?? traditionalChineseRouteName
    }
    var englishDestination: String {
        englishRouteName.components(separatedBy: " > ").last ?? englishRouteName
    }
    var simplifiedChineseDestination: String {
        simplifiedChineseRouteName.components(separatedBy: " > ").last ?? simplifiedChineseRouteName
    }
    var traditionalChineseDestination: String {
        traditionalChineseRouteName.components(separatedBy: " > ").last ?? traditionalChineseRouteName
    }
    
    enum CodingKeys: String, CodingKey {
        case routeID = "routeId"
        case routeNo
        case isSpecialRouteInt = "specialRoute"
        case isOvernightRouteInt = "overnightRoute"
        case englishRouteName = "routeName_e"
        case simplifiedChineseRouteName = "routeName_s"
        case traditionalChineseRouteName = "routeName_c"
    }
}
