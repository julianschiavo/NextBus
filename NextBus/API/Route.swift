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
    var companyID: CompanyID
    
    var id: String = ""
    var name: String
    
    // Only used for NLB routes to avoid duplicating one way routes
    var isOneWay: Bool
    
    var fare: String?
    var holidayFare: String?
    
    var isSpecial: Bool
    var isOvernight: Bool
    
    var generated: Date
    
    var origin: String {
        LocalizedText(en: englishOrigin, sc: simplifiedChineseOrigin, tc: traditionalChineseOrigin).current
    }
    var englishOrigin: String
    var simplifiedChineseOrigin: String
    var traditionalChineseOrigin: String
    
    var destination: String {
        LocalizedText(en: englishDestination, sc: simplifiedChineseDestination, tc: traditionalChineseDestination).current
    }
    var englishDestination: String
    var simplifiedChineseDestination: String
    var traditionalChineseDestination: String
    
    func matches(_ searchText: String) -> Bool {
        if name.lowercased().contains(searchText) { return true }
        if origin.lowercased().contains(searchText) { return true }
        if destination.lowercased().contains(searchText) { return true }
        
        if isOneWay {
            return APIManager.shared.stopNameIndex(for: self, in: .oneWay).contains(searchText)
        } else {
            return APIManager.shared.stopNameIndex(for: self, in: .inbound).contains(searchText) ||
                APIManager.shared.stopNameIndex(for: self, in: .outbound).contains(searchText)
        }
    }
    
    @available(*, unavailable, message: "Favoriting is now per route in a direction from a stop")
    var isFavorite: Bool {
        guard let favorites = UserDefaults.shared.array(forKey: "FavoriteRoutes") as? [String] else { return false }
        return favorites.contains(companyID.rawValue + name)
    }
    
    @available(*, unavailable, message: "Favoriting is now per route in a direction from a stop")
    func setFavorite(_ favorite: Bool) {
        var favorites = UserDefaults.shared.array(forKey: "FavoriteRoutes") as? [String] ?? []

        if favorite == true {
            favorites.append(companyID.rawValue + name)
        } else {
            guard let index = favorites.firstIndex(of: companyID.rawValue + name) else { return }
            favorites.remove(at: index)
        }
        
        UserDefaults.shared.set(favorites, forKey: "FavoriteRoutes")
    }
    
    // MARK: - Intents
    
    static func from(intentObject: INRoute) -> Route? {
        guard let name = intentObject.name,
            let origin = intentObject.origin,
            let destination = intentObject.destination,
            let isOneWayNSNumber = intentObject.isOneWay,
            let isOneWay = Bool(exactly: isOneWayNSNumber),
            let companyID = CompanyID(rawValue: intentObject.companyID ?? "") else { return nil }
        
        return Route(companyID: companyID, name: name, isOneWay: isOneWay, isSpecial: false, isOvernight: false, generated: Date(), englishOrigin: origin, simplifiedChineseOrigin: origin, traditionalChineseOrigin: origin, englishDestination: destination, simplifiedChineseDestination: destination, traditionalChineseDestination: destination)
    }
    
    var intentObject: INRoute {
        let object = INRoute(identifier: id, display: "Route \(name)")
        object.companyID = companyID.rawValue
        object.name = name
        object.isOneWay = NSNumber(value: isOneWay)
        object.origin = origin
        object.destination = destination
        return object
    }
}
