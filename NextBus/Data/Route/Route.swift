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
    var id: String {
        _id + direction.rawValue
    }
    var _id: String
    var companyID: CompanyID
    
    var name: LocalizedText
    var localizedName: String {
        name.current
    }
    
    var description: LocalizedText?
    var localizedDescription: String? {
        description?.current
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
    
    var lastUpdated: Date
}
