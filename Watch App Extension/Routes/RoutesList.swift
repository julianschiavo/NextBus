//
//  RoutesList.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Loadability
import SwiftUI

struct RoutesList: View, LoadableView {
    @StateObject var loader = RoutesLoader()
    
    @State private var searchText = ""
    
    var body: some View {
        loaderView
    }
    
    func body(with companyRoutes: [CompanyRoutes]) -> some View {
        List {
            ForEach(companyRoutes) { group in
                NavigationLink(destination: CompanyRoutesList(routes: group.routes, searchText: $searchText)) {
                    Label {
                        Text(group.company.name)
                    } icon: {
                        group.company.category.image
                    }
                    .foregroundColor(group.company.color)
                }
            }
        }
        .listStyle(.carousel)
    }
    
    func placeholder() -> some View {
        ProgressView(Localizable.loadingRoutes)
    }
}
