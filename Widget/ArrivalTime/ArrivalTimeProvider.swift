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
    
    private var cancellables = Set<AnyCancellable>()
    private var loaders = [ETALoader]()
    private let store = Store()
    
    init() { }
    
    func placeholder(in context: Context) -> ArrivalTimeEntry {
        .placeholder
    }
    
    func getSnapshot(for configuration: SelectRouteStopIntent, in context: Context, completion: @escaping (ArrivalTimeEntry) -> ()) {
        completion(.placeholder)
    }
    
    func getTimeline(for configuration: SelectRouteStopIntent, in context: Context, completion: @escaping (Timeline<ArrivalTimeEntry>) -> ()) {
        let routeStops = routeStopsFromConfiguration(configuration)
        guard !routeStops.isEmpty else {
            let entry = ArrivalTimeEntry(date: Date(), configuration: configuration, data: .errorNoRoutesSelected)
            let refreshDate = Date().addingTimeInterval(900)
            completion(Timeline(entries: [entry], policy: .after(refreshDate)))
            return
        }
        
//        createPublisher(for: routeStops.first!).sink { time in
//        let time = ArrivalTimeEntry.RouteArrival(route: routeStops.first!.route, stop: routeStops.first!.stop, eta: ETA(id: nil, date: Date().addingTimeInterval(600), generated: Date(), remark: LocalizedText(""), message: nil))
//            let entry = ArrivalTimeEntry(date: Date(), configuration: configuration, data: .arrivals([time]))
//            let refreshDate = Date().addingTimeInterval(600)
//            if time.eta != nil {
//                completion(Timeline(entries: [entry], policy: .after(refreshDate)))
//            }

//        }
//        .store(in: &cancellables)
        let count = context.family == .systemSmall ? 1 : 4
        let publishers = routeStops.compactMap(createPublisher).prefix(count)
        Publishers.MergeMany(publishers)
            .collect()
            .compactMap {
                $0
            }
            .sink { times in
                let entry = ArrivalTimeEntry(date: Date(), configuration: configuration, data: .arrivals(times))
                let refreshDate = Date().addingTimeInterval(600)
                completion(Timeline(entries: [entry], policy: .after(refreshDate)))
            }
            .store(in: &cancellables)
    }
    
    private func createPublisher(for routeStop: RouteStop) -> AnyPublisher<ArrivalTimeEntry.RouteArrival, Never>? {
        guard routeStop.companyID.supportsETA else { return nil }
        
        let loader = ETALoader()
        loaders.append(loader)
        return loader.createPublisher(key: routeStop)?
//            .drop {
//                $0 == nil
//            }
            .first()
            .replaceError(with: [])
            .map { etas in
                ArrivalTimeEntry.RouteArrival(route: routeStop.route, stop: routeStop.stop, etas: etas)
            }
            .eraseToAnyPublisher()
    }
    
    private func routeStopsFromConfiguration(_ configuration: SelectRouteStopIntent) -> [RouteStop] {
        var routeStops = [RouteStop]()
        
        if configuration.source == .favorites {
            let favorites = configuration.favorites?.compactMap(RouteStop.from) ?? store.favorites.load()
            routeStops.append(contentsOf: favorites)
        }
        
        if configuration.source == .recents {
            let recents = store.recents.load()
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
