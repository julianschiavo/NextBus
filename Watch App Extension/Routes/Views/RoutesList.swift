//
//  RoutesList.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RoutesList: View, Loadable {
    @StateObject var loader = RoutesLoader()
    
    @State private var searchText = ""
    
    var body: some View {
        loaderView
    }
    
    func body(with companyRoutes: [CompanyRoutes]) -> some View {
        List {
            ForEach(companyRoutes) { group in
                NavigationLink(destination: CompanyRoutesList(routes: group.routes, searchText: $searchText)) {
                    Label(group.company.name, systemImage: group.company.category.iconName)
                        .foregroundColor(group.company.color)
                }
            }
        }
        .listStyle(CarouselListStyle())
    }
    
    func placeholder() -> some View {
        ProgressView("Loading Routes...")
    }
}
