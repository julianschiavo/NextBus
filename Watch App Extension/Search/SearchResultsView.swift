//
//  SearchResultsView.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 8/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct SearchResultsView: View {
    
    @ObservedObject var routeDataManager = RouteDataManager.shared
    
    let originalSearchText: String
    let searchText: String
    
    private let previewRoutes: [Route]?
    
    // previewRoutes are only used for the SwiftUI Preview
    init(searchText: String, previewRoutes: [Route]? = nil) {
        originalSearchText = searchText
        self.searchText = searchText.lowercased()
        self.previewRoutes = previewRoutes
    }
    
    var body: some View {
        let allRoutes = previewRoutes ?? routeDataManager.routes
        let routes = allRoutes.filter { $0.matches(searchText) }
        
        if searchText.isEmpty {
            return Erase {
                Text(Localizations.errorEmptySearch)
                    .title()
            }
            
        } else if routes.isEmpty {
            return Erase {
                Message(imageName: "nosign",
                        title: Localizations.errorNoResultsTitle,
                        subtitle: Localizations.errorNoResultsText)
            }
            
        } else {
            return Erase {
                RouteListView(routes: routes)
                    .navigationBarTitle(Localizations.searchResults(searchText: originalSearchText))
            }
        }
    }
}

#if DEBUG
struct SearchResultsView_Previews: PreviewProvider {
    static let routes = [Route(companyID: .nwfb, id: "1", name: "1", isOneWay: false, isSpecial: false, isOvernight: false, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination"),
                         Route(companyID: .nwfb, id: "2", name: "133X", isOneWay: true, isSpecial: true, isOvernight: false, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination"),
                         Route(companyID: .nlb, id: "3", name: "N39", isOneWay: false, isSpecial: false, isOvernight: true, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination")]

    static var previews: some View {
        Group {
            SearchResultsView(searchText: "1", previewRoutes: routes)
            SearchResultsView(searchText: "Gobbledygook")
            SearchResultsView(searchText: "")
        }
    }
}
#endif
