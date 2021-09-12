//
//  ArrivalTimeProvider.swift
//  Clip
//
//  Created by Julian Schiavo on 13/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Intents
import WidgetKit

class ArrivalTimeProvider: IntentTimelineProvider {
    
    private var loaders = [ETALoader]()
    private let payBuddy = PayBuddy()
    
    init() { }
    
    func placeholder(in context: Context) -> ArrivalTimeEntry {
        .placeholder
    }
    
    
    func getSnapshot(for configuration: SelectRouteStopIntent, in context: Context, completion: @escaping (ArrivalTimeEntry) -> ()) {
        completion(.placeholder)
    }
    
    func getTimeline(for configuration: SelectRouteStopIntent, in context: Context, completion: @escaping (Timeline<ArrivalTimeEntry>) -> ()) {
        Task {
            let hasPlus = await payBuddy.loadStatus()
            
            guard hasPlus else {
                let entry = ArrivalTimeEntry.upgradeRequired(configuration: configuration)
                let refreshDate = Date().addingTimeInterval(3600)
                completion(Timeline(entries: [entry], policy: .after(refreshDate)))
                return
            }
            
            let timeline = await createTimeline(for: configuration, in: context)
            completion(timeline)
        }
    }
        
    private func createTimeline(for configuration: SelectRouteStopIntent, in context: Context) async -> Timeline<ArrivalTimeEntry> {
        let routeStops = await routeStopsFromConfiguration(configuration)
        
        guard !routeStops.isEmpty else {
            let entry = ArrivalTimeEntry.noRoutesSelected(configuration: configuration)
            let refreshDate = Date().addingTimeInterval(900)
            return Timeline(entries: [entry], policy: .after(refreshDate))
        }
        
        let count = context.family == .systemSmall ? 1 : 4
        
        return await withTaskGroup(of: ArrivalTimeEntry.RouteArrival?.self) { group -> Timeline<ArrivalTimeEntry> in
            for routeStop in routeStops.prefix(count) {
                group.async {
                    await self.routeArrival(for: routeStop)
                }
            }
            
            var times = [ArrivalTimeEntry.RouteArrival]()
            for await time in group {
                guard let time = time else { continue }
                times.append(time)
            }
            
            let entry = ArrivalTimeEntry(date: Date(), configuration: configuration, data: .arrivals(times))
            let refreshDate = Date().addingTimeInterval(600)
            return Timeline(entries: [entry], policy: .after(refreshDate))
        }
    }
    
    @MainActor private func routeArrival(for routeStop: RouteStop) async -> ArrivalTimeEntry.RouteArrival? {
        guard routeStop.companyID.supportsETA else { return nil }
        
        let loader = ETALoader()
        loaders.append(loader)
        
        let _etas = try? await loader
            .loadData(key: routeStop)
            .compactMap { $0 }
        guard let etas = _etas else { return nil }
        
        return ArrivalTimeEntry.RouteArrival(route: routeStop.route, stop: routeStop.stop, etas: etas)
    }
    
    private func routeStopsFromConfiguration(_ configuration: SelectRouteStopIntent) async -> [RouteStop] {
        var routeStops = [RouteStop]()
        
        if configuration.source == .favorites {
            let storeFavorites = await Store.shared.favorites.load()
            let favorites = configuration.favorites?.compactMap(RouteStop.from) ?? storeFavorites
            routeStops.append(contentsOf: favorites)
        }
        
        if configuration.source == .recents {
            let recents = await Store.shared.recents.load()
            routeStops.append(contentsOf: recents)
        }
        
        if let inRoute = configuration.firstRoute,
           let inStop = configuration.firstStop,
           let route = Route.from(inRoute),
           let stop = Stop.from(inStop) {
            
            let routeStop = RouteStop(route: route, stop: stop)
            routeStops.append(routeStop)
        }
        
        if let inRoute = configuration.secondRoute,
           let inStop = configuration.secondStop,
           let route = Route.from(inRoute),
           let stop = Stop.from(inStop) {
            
            let routeStop = RouteStop(route: route, stop: stop)
            routeStops.append(routeStop)
        }
        
        if let inRoute = configuration.thirdRoute,
           let inStop = configuration.thirdStop,
           let route = Route.from(inRoute),
           let stop = Stop.from(inStop) {
            
            let routeStop = RouteStop(route: route, stop: stop)
            routeStops.append(routeStop)
        }
        
        if let inRoute = configuration.fourthRoute,
           let inStop = configuration.fourthStop,
           let route = Route.from(inRoute),
           let stop = Stop.from(inStop) {
            
            let routeStop = RouteStop(route: route, stop: stop)
            routeStops.append(routeStop)
        }
        
        return routeStops
    }
}
