//
//  RoutesList.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
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
            if searchText.isEmpty {
                sectionList(with: companyRoutes)
            } else {
                filteredList(with: companyRoutes)
            }
        }
        .listStyle(SidebarListStyle())
        .navigationBarSearch($searchText)
    }
    
    private func sectionList(with companyRoutes: [CompanyRoutes]) -> some View {
        ForEach(companyRoutes) { group in
            DisclosureGroup {
                ForEach(group.routes) { route in
                    RouteRow(route: route)
                }
            } label: {
                Label(
                    title: {
                        Text(group.company.name)
                    },
                    icon: {
                        Image(systemName: group.company.category.iconName)
                            .foregroundColor(group.company.color)
                    }
                )
                .font(.largeHeadline, weight: .medium)
            }
        }
    }
    
    private func filteredList(with companyRoutes: [CompanyRoutes]) -> some View {
        ForEach(companyRoutes) { group in
            DisclosureGroup(isExpanded: .constant(true)) {
                ForEach(group.routes.filter { searchText.isEmpty || $0.localizedName.localizedCaseInsensitiveContains(searchText) }) { route in
                    RouteRow(route: route)
                }
            } label: {
                Label(
                    title: {
                        Text(group.company.name)
                    },
                    icon: {
                        Image(systemName: group.company.category.iconName)
                            .foregroundColor(group.company.color)
                    }
                )
                .font(.largeHeadline, weight: .medium)
            }
        }
    }
    
    func placeholder() -> some View {
        ProgressView("Loading Routes...")
    }
}
