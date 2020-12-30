//
//  FavoritesView.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 14/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct FavoritesView: View {
    
    struct Item: Identifiable {
        var id: String { "\(route.id)\(route.name)\(direction.rawValue)\(stop.id)" }
        var route: Route
        var direction: Direction
        var stop: Stop
        
        var description: String {
            Localizations.routeOriginAndDestination(origin: stop.name, destination: direction.destination(for: route))
        }
    }
    
    private let previewFavorites: [(Route, Direction, Stop)]?
    
    // previewRoutes are only used for the SwiftUI Preview
    init(previewFavorites: [(Route, Direction, Stop)]? = nil) {
        self.previewFavorites = previewFavorites
    }
    
    var body: some View {
        let favorites = previewFavorites ?? APIManager.shared.favorites().sorted { $0.0.name < $1.0.name }
        let items = favorites.map { Item(route: $0.0, direction: $0.1, stop: $0.2) }
        
        if favorites.isEmpty {
            return Erase {
                Message(imageName: "heart",
                        title: Localizations.errorNoFavoritesTitle,
                        subtitle: Localizations.errorNoFavoritesText)
            }
            
        } else {
            return Erase {
                List {
                    ForEach(items) { favorite in
                        NavigationLink(destination: RouteDetailView(route: favorite.route, direction: favorite.direction, stop: favorite.stop)) {
                            HStack {
                                Text(favorite.route.name)
                                    .font(.title)
                                    .layoutPriority(1)
                                Text(favorite.description)
                                    .font(.subheadline)
                            }
                            .padding([.top, .bottom])
                        }
                    }
                }
                .listStyle(CarouselListStyle())
                .navigationBarTitle(Localizations.favoritesHeader)
            }
        }
    }
}

#if DEBUG
struct FavoritesView_Previews: PreviewProvider {
    static let favorites = [(Route(companyID: .nwfb, id: "1", name: "1", isOneWay: false, isSpecial: false, isOvernight: false, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination"), Direction.inbound, Stop(id: "1", index: nil, generated: Date(), englishName: "Stop", simplifiedChineseName: "Stop", traditionalChineseName: "Stop", normalFare: nil, holidayFare: nil, specialDeparturesOnly: false, latitude: 1, longitude: 1)),
                         (Route(companyID: .nwfb, id: "2", name: "133X", isOneWay: true, isSpecial: true, isOvernight: false, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination"), Direction.inbound, Stop(id: "2", index: nil, generated: Date(), englishName: "Stop", simplifiedChineseName: "Stop", traditionalChineseName: "Stop", normalFare: nil, holidayFare: nil, specialDeparturesOnly: false, latitude: 2, longitude: 2))]

    static var previews: some View {
        Group {
            FavoritesView(previewFavorites: favorites)
            FavoritesView()
        }
    }
}
#endif
