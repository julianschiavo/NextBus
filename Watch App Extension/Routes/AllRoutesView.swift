//
//  AllRoutesView.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 7/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Combine
import SwiftUI

struct AllRoutesView: View {

    @ObservedObject var routeDataManager = RouteDataManager.shared

    private let previewRoutes: [Route]?
    
    // previewRoutes are only used for the SwiftUI Preview
    init(previewRoutes: [Route]? = nil) {
        self.previewRoutes = previewRoutes
    }
    
    func refresh() {
        routeDataManager.reloadData()
    }
    
    var body: some View {
        let routes = previewRoutes ?? routeDataManager.routes
        let routeListView = RouteListView(routes: routes).navigationBarTitle(Localizations.allRoutesHeader)

        if let error = routeDataManager.error {
            return Erase {
                Message(imageName: "exclamationmark.triangle",
                        title: Localizations.error,
                        subtitle: error.localizedDescription) {
                    self.refresh()
                }
            }
            
        } else if routes.isEmpty {
            return Erase {
                Message(imageName: "stopwatch",
                        title: Localizations.loadingRoutesTitle,
                        subtitle: Localizations.loadingRoutesText) {
                    self.refresh()
                }
            }
            
        } else {
            return Erase { routeListView }
        }
    }
}
//
//#if DEBUG
//struct AllRoutesView_Previews: PreviewProvider {
//    static let routes = [Route(companyID: .nwfb, id: "1", name: "1", isOneWay: false, isSpecial: false, isOvernight: false, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination"),
//                         Route(companyID: .nwfb, id: "2", name: "133X", isOneWay: true, isSpecial: true, isOvernight: false, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination"),
//                         Route(companyID: .nlb, id: "3", name: "N39", isOneWay: false, isSpecial: false, isOvernight: true, generated: Date(), englishOrigin: "Origin", simplifiedChineseOrigin: "Origin", traditionalChineseOrigin: "Origin", englishDestination: "Destination", simplifiedChineseDestination: "Destination", traditionalChineseDestination: "Destination")]
//    
//    static var previews: some View {
//        Group {
//            AllRoutesView(previewRoutes: routes)
//            AllRoutesView(previewRoutes: [])
//        }
//    }
//}
//#endif
