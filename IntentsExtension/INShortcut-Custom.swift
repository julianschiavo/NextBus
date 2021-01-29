//
//  INShortcut-Custom.swift
//  IntentsExtension
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Intents

extension INShortcut {
    static func getUpcomingBuses() -> INShortcut {
        let intent = GetUpcomingBusesIntent()
        intent.suggestedInvocationPhrase = "When's the next bus?"
        return INShortcut(intent: intent) ?? INShortcut(userActivity: NSUserActivity(activityType: ""))
    }
    
    static func getUpcomingBuses(route: Route) -> INShortcut {
        let intent = GetUpcomingBusesIntent()
        intent.source = .custom
        intent.route = route.intent
        intent.suggestedInvocationPhrase = "When's the next \(route.localizedName)?"
        return INShortcut(intent: intent) ?? INShortcut(userActivity: NSUserActivity(activityType: ""))
    }
    
    static func getUpcomingBuses(route: Route, stop: Stop) -> INShortcut {
        let intent = GetUpcomingBusesIntent()
        intent.source = .custom
        intent.route = route.intent
        intent.stop = stop.intent
        intent.suggestedInvocationPhrase = "When's the next \(route.localizedName) from \(stop.localizedName)?"
        return INShortcut(intent: intent) ?? INShortcut(userActivity: NSUserActivity(activityType: ""))
    }
}
