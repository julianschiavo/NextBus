//
//  RoutesList.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Loadability
import SwiftUI

struct RoutesList: View, LoadableView {
    @StateObject var loader = RoutesLoader()
    
    @State private var searchText = ""
    
    @State private var companyState = [Company: Bool]()
    
    var body: some View {
        loaderView
    }
    
    func body(with companyRoutes: [CompanyRoutes]) -> some View {
        List {
            ForEach(companyRoutes) { group in
                if searchText.isEmpty {
                    sectionList(for: group)
                } else {
                    filteredList(for: group)
                }
            }
        }
        .macMinFrame(width: 260)
        .macMaxFrame(width: 500)
        .listStyle(SidebarListStyle())
        .navigationBarSearch($searchText) {
            RouteSearchToolbar(searchText: $searchText)
        }
    }
    
    private func sectionList(for group: CompanyRoutes) -> some View {
        DisclosureGroup {
            ForEach(group.routes) { route in
                NavigationLink(destination: BusDetail(route: route)) {
                    RouteRow(route: route)
                }
            }
        } label: {
            companyLabel(group.company)
        }
    }
    
    @ViewBuilder private func filteredList(for group: CompanyRoutes) -> some View {
        if !filteredRoutes(group.routes).isEmpty {
            DisclosureGroup(isExpanded: expansionBinding(for: group.company)) {
                ForEach(filteredRoutes(group.routes)) { route in
                    NavigationLink(destination: BusDetail(route: route)) {
                        RouteRow(route: route)
                    }
                }
            } label: {
                companyLabel(group.company)
            }
        }
    }
    
    private func companyLabel(_ company: Company) -> some View {
        Label(
            title: {
                Text(company.name)
            },
            icon: {
                Image(systemName: company.category.iconName)
                    .foregroundColor(company.color)
            }
        )
        .accentColor(company.color)
        .font(.largeHeadline, weight: .medium)
    }
    
    private func expansionBinding(for company: Company) -> Binding<Bool> {
        Binding {
            companyState[company, default: true]
        } set: { _,_ in
            companyState[company] = !companyState[company, default: true]
        }
    }
    
    private func filteredRoutes(_ routes: [Route]) -> [Route] {
        routes.filter {
            $0.localizedName.lowercased().hasPrefix(searchText.lowercased())
        }
    }
    
    func placeholder() -> some View {
        ProgressView(Localizable.loadingRoutes)
    }
}
