//
//  ArrivalTimeEntry.swift
//  Clip
//
//  Created by Julian Schiavo on 13/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Intents
import WidgetKit

struct ArrivalTimeEntry: TimelineEntry {
    struct RouteArrival: Identifiable {
        let route: Route
        let stop: Stop
        var etas: [ETA]
        
        var id: String { route.id + stop.id }
    }
    
    enum Data {
        case arrivals([RouteArrival])
        case errorNoRoutesSelected
        case errorFailedToLoad
        case errorUpgradeRequired
    }
    
    let date: Date
    let configuration: SelectRouteStopIntent
    let data: Data
    
    static var placeholder: ArrivalTimeEntry {
        let name = LocalizedText("SSH")
        let text = LocalizedText("Next Bus (Central)")
        let date = Calendar.current.date(bySettingHour: 11, minute: 11, second: 11, of: Date()) ?? Date()
        let arrivals = [
            RouteArrival(
                route: Route(_id: "1", company: .nwfb, name: name, description: text, category: .bus, servicePeriod: .allDay, direction: .outbound, fare: 0, origin: text, destination: text, lastUpdated: Date()),
                stop: Stop(id: "1", index: 0, name: text, latitude: nil, longitude: nil, lastUpdated: Date()),
                etas: [ETA(id: "1", date: date, generated: Date(), remark: text, message: nil)]
            ),
            RouteArrival(
                route: Route(_id: "2", company: .kmb, name: name, description: text, category: .bus, servicePeriod: .allDay, direction: .outbound, fare: 0, origin: text, destination: text, lastUpdated: Date()),
                stop: Stop(id: "2", index: 0, name: text, latitude: nil, longitude: nil, lastUpdated: Date()),
                etas: [ETA(id: "2", date: date, generated: Date(), remark: text, message: nil)]
            ),
            RouteArrival(
                route: Route(_id: "3", company: .nlb, name: name, description: text, category: .bus, servicePeriod: .allDay, direction: .outbound, fare: 0, origin: text, destination: text, lastUpdated: Date()),
                stop: Stop(id: "3", index: 0, name: text, latitude: nil, longitude: nil, lastUpdated: Date()),
                etas: [ETA(id: "3", date: date, generated: Date(), remark: text, message: nil)]
            ),
            RouteArrival(
                route: Route(_id: "4", company: .ctb, name: name, description: text, category: .bus, servicePeriod: .allDay, direction: .outbound, fare: 0, origin: text, destination: text, lastUpdated: Date()),
                stop: Stop(id: "4", index: 0, name: text, latitude: nil, longitude: nil, lastUpdated: Date()),
                etas: [ETA(id: "4", date: date, generated: Date(), remark: text, message: nil)]
            )
        ]
        return ArrivalTimeEntry(date: Date(), configuration: SelectRouteStopIntent(), data: .arrivals(arrivals))
    }
}
