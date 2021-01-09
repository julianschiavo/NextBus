//
//  RouteListView.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 8/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RouteListView: View {
    struct Item: Hashable, Identifiable {
        var id: String { "\(route.id) \(route.name) \(direction.rawValue)" }
        var route: Route
        var direction: Direction
        var description: String {
            let origin = direction.origin(for: route)
            let destination = direction.destination(for: route)
            return Localizations.routeOriginAndDestination(origin: origin, destination: destination)
        }
    }
    
    @State var routes: [Route]
    
    var body: some View {
        let items = routes.map { route -> [Item] in
//            if route.isOneWay {
//                return [Item(route: route, direction: .oneWay)]
//            } else {
                return [Item(route: route, direction: .inbound), Item(route: route, direction: .outbound)]
//            }
        }.flatMap { $0 }
        
        return List {
            ForEach(items) { item in
                NavigationLink(destination: StopListView(route: item.route, direction: item.direction)) {
                    HStack {
                        Text(item.route.name)
                            .font(.title)
                            .layoutPriority(1)
                        Text(item.description)
                            .font(.subheadline)
                    }
                    .padding([.top, .bottom])
                }
            }
        }
        .listStyle(CarouselListStyle())
    }
}

//#if DEBUG
//struct RouteListView_Previews: PreviewProvider {
//    static let routes = [Route(companyID: .nwfb, id: "1", name: "1", isOneWay: false, isSpecial: false, isOvernight: false, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination"),
//                         Route(companyID: .nwfb, id: "2", name: "133X", isOneWay: false, isSpecial: true, isOvernight: false, generated: Date(), englishOrigin: "Origin2", simplifiedChineseOrigin: "Origin2", traditionalChineseOrigin: "Origin2", englishDestination: "Destination2", simplifiedChineseDestination: "Destination2", traditionalChineseDestination: "Destination2")]
//    
//    static var previews: some View {
//        return RouteListView(routes: routes)
//    }
//}
//#endif
