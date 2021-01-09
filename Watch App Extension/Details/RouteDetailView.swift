//
//  RouteDetailView.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RouteDetailView: View {
    
    let route: Route
    let direction: Direction
    let stop: Stop
    
    private let favorite: Favorite
    @State private var isFavorite = false
    
    @State private var etas: [ETA]?
    @State private var error: Error?
    private let unknownETA: ETA
    
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    init(route: Route, direction: Direction, stop: Stop) {
        self.route = route
        self.direction = direction
        self.stop = stop
        self.favorite = Favorite(route: route, direction: direction, stop: stop)
        
        unknownETA = ETA.unknown(for: route, direction: direction)
        
        isFavorite = APIManager.shared.isFavorite(favorite: favorite)
    }
    
    func refresh() {
        isFavorite = APIManager.shared.isFavorite(favorite: favorite)
        APIManager.shared.fetchETA(for: route, in: direction, stop: stop, priority: .normal) { result in
            switch result {
            case let .success(etas):
                self.etas = etas.sorted {
                    guard let firstDate = $0.date, let secondDate = $1.date else { return false }
                    return firstDate < secondDate
                }
            case let .failure(newError):
                self.error = newError
            }
        }
    }
    
    var body: some View {
        
        var favoriteImage: Image
        var favoriteText: Text
        if isFavorite {
            favoriteImage = Image(systemName: "heart.fill")
            favoriteText = Text(Localizations.unfavoriteButton)
        } else {
            favoriteImage = Image(systemName: "heart")
            favoriteText = Text(Localizations.favoriteButton)
        }
        
        let header = HStack {
            VStack(alignment: .leading) {
                Text(Localizations.routeTitle(routeName: route.name))
                    .title()
                Text(Localizations.routeOriginAndDestination(origin: stop.localizedName, destination: direction.destination(for: route)))
                    .subtitle()
            }
            Spacer()
            Button(action: {
                self.setFavorite()
            }) {
                favoriteImage
                    .foregroundColor(.red)
                    .imageScale(.large)
                    .font(.headline)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding([.top, .bottom])
        
        let list = List {
            header
            
            Section(header: ListSectionHeader(imageName: "clock", text: Localizations.detailsArrivingSoonHeader)) {
                if etas != nil && etas?.isEmpty == false {
                    ForEach(etas!) { eta in
                        ETAView(eta: eta)
                    }
                } else {
                    ETAView(eta: unknownETA)
                }
            }
            
            Section(header: ListSectionHeader(imageName: "map", text: Localizations.detailsMapHeader), footer: Text(Localizations.detailsMapFooter).foregroundColor(.secondary)) {
                Map(latitude: stop.latitude, longitude: stop.longitude).listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .frame(height: 100)
            }
        }
        .onReceive(timer) { _ in self.refresh() }
        .listStyle(PlainListStyle())
        .navigationBarTitle(Localizations.routeTitle(routeName: route.name))
        .contextMenu {
            Button(action: {
                self.setFavorite()
            }) {
                VStack {
                    favoriteText
                    favoriteImage
                        .foregroundColor(.red)
                }
            }
        }
        
        if let error = error {
            return Erase {
                Message(imageName: "exclamationmark.triangle",
                        title: Localizations.error,
                        subtitle: error.localizedDescription) {
                    self.refresh()
                }
            }
            
        } else if etas == nil {
            return Erase {
                Message(imageName: "stopwatch",
                        title: Localizations.loadingArrivalInfoTitle,
                        subtitle: Localizations.loadingArrivalInfoText) {
                    self.refresh()
                }
            }
            
        } else {
            return Erase { list }
        }
    }
    
    func setFavorite() {
        if APIManager.shared.isFavorite(favorite: favorite) {
            APIManager.shared.setFavorite(false, favorite: favorite)
            isFavorite = false
        } else {
            APIManager.shared.setFavorite(true, favorite: favorite)
            isFavorite = true
        }
    }
}

#if DEBUG
//struct RouteDetailView_Previews: PreviewProvider {
//    static let route = Route(companyID: .nwfb, id: "1", name: "1", isOneWay: false, isSpecial: true, isOvernight: false, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination")
//    static let direction = Direction.inbound
//    static let stop = Stop(id: "1", index: nil, generated: Date(), englishName: "Stop", simplifiedChineseName: "Stop", traditionalChineseName: "Stop", normalFare: nil, holidayFare: nil, specialDeparturesOnly: false, latitude: 1, longitude: 1)
//    
//    static var previews: some View {
//        Group {
//            RouteDetailView(route: route, direction: direction, stop: stop)
//        }
//    }
//}
#endif
