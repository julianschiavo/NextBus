//
//  ContentView.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 26/12/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import SwiftUI
import WatchKit

enum ViewType: String, Identifiable, CaseIterable {
    case favorites
    case search
    case allRoutes
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .allRoutes:
            return Localizations.allRoutesHeader
        case .favorites:
            return Localizations.favoritesHeader
        case .search:
            return Localizations.searchHeader
        }
    }
    
    var image: Image? {
        switch self {
        case .allRoutes:
            return Image(systemName: "list.bullet")
        case .favorites:
            return Image(systemName: "heart")
        case .search:
            return Image(systemName: "magnifyingglass")
        }
    }
    
    @ViewBuilder var view: some View {
        switch self {
        case .allRoutes:
            return AllRoutesView()
        case .favorites:
            return FavoritesView()
        case .search:
            return SearchView()
        }
    }
}

struct HomeView: View {
    var body: some View {
        List {
            ForEach(ViewType.allCases) { viewType in
                NavigationLink(destination: viewType.view) {
                    HStack {
                        viewType.image
                            .font(.headline)
                            .frame(width: 25, height: 25)
                            .aspectRatio(contentMode: .fit)
                            .imageScale(.large)
                        Text(viewType.name)
                    }
                    .padding([.top, .bottom])
                }
            }
        }
        .navigationBarTitle(Localizations.nextBus)
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
