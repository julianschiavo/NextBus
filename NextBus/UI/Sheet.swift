//
//  Sheet.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

enum Sheet: Identifiable {
    case addToSiri(route: Route?, stop: Stop?)
    case editSchedule(block: ScheduleBlock)
    case newSchedule(route: Route?, stop: Stop?)
    case pickDirections(origin: MKMapItem, destination: MKMapItem, selection: Binding<Routing?>)
    case pickRoute(route: Binding<Route?>)
    case pickStop(route: Route, stop: Binding<Stop?>)
    case shareSheet(route: Route, stop: Stop?)
    
    var id: String {
        switch self {
        case let .addToSiri(route, stop):
            return "addToSiri\(route?.id ?? "")\(stop?.id ?? "")"
        case let .editSchedule(block):
            return "newSchedule\(block.id)"
        case let .newSchedule(route, stop):
            return "newSchedule\(route?.id ?? "")\(stop?.id ?? "")"
        case .pickDirections:
            return "pickDirections"
        case .pickRoute:
            return "pickRoute"
        case let .pickStop(route, _):
            return "pickStop\(route.id)"
        case let .shareSheet(route, stop):
            return "shareSheet\(route.id)\(stop?.id ?? "")"
        }
    }
    
    @ViewBuilder var content: some View {
        switch self {
        default:
            #if MAIN
            mainAppContent
            #endif
        }
    }
    
    #if MAIN
    @ViewBuilder var mainAppContent: some View {
        switch self {
        case let .shareSheet(route, stop):
            RouteShareSheet(route: route, stop: stop)
        case let .addToSiri(route, stop):
            #if os(iOS)
            AddVoiceShortcutViewController(route: route, stop: stop)
            #endif
        case let .editSchedule(block):
            EditSchedule(block)
        case let .newSchedule(route, stop):
            NewSchedule(route: route, stop: stop)
        case let .pickDirections(origin, destination, selection):
            RoutingPicker(origin: origin, destination: destination, selection: selection)
        case let .pickRoute(route):
            RoutePicker(selection: route)
        case let .pickStop(route, stop):
            StopPicker(route: route, selection: stop)
        }
    }
    #endif
}

//enum Sheet: String, Identifiable {
//    case routePicker
//    case stopPicker
//
//    var id: String { rawValue }
//
//    @ViewBuilder func view(route: Route?, routeBinding: Binding<Route?>, stop: Binding<Stop?>) -> some View {
//        switch self {
//        case .routePicker:
//            RoutePicker(selection: routeBinding)
//        case .stopPicker:
//            if let route = route {
//                StopPicker(route: route, selection: stop)
//            }
//        }
//    }
//}

extension View {
    func globalSheet(_ sheet: Binding<Sheet?>) -> some View {
        self.sheet(item: sheet) { sheet in
            sheet.content
        }
    }
}

struct RouteShareSheet: View {
    let route: Route
    var stop: Stop?
    
    private var shareURL: URL {
        StatusExperience(company: route.company, routeID: route.id, stopID: stop?.id).toURL() ?? URL(fileURLWithPath: "")
    }
    
    var body: some View {
        ShareSheet(items: [shareURL], activities: nil)
    }
}
