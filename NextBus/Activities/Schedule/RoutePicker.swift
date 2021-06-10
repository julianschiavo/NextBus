//
//  RoutePicker.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Loadability
import SwiftUI

struct RoutePicker: View, LoadableView {
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var selection: Route?
    
    @StateObject var loader = RoutesLoader()
    
    @State private var searchText = ""
    
    @State private var companyState = [Company: Bool]()
    
    var body: some View {
        NavigationView {
            loaderView
                .macMinFrame(width: 700, height: 500)
                .navigationTitle(Localizable.selectRoute)
                .navigationTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .confirmationAction) {
                        Button(Localizable.done) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
        .listStyle(SidebarListStyle())
        .navigationBarSearch($searchText) {
            RouteSearchToolbar(searchText: $searchText)
        }
    }
    
    private func sectionList(for group: CompanyRoutes) -> some View {
        DisclosureGroup(isExpanded: expansionBinding(for: group.company, default: false)) {
            ForEach(group.routes) { route in
                row(for: route)
            }
        } label: {
            companyLabel(group.company)
        }
    }
    
    @ViewBuilder private func filteredList(for group: CompanyRoutes) -> some View {
        if !filteredRoutes(group.routes).isEmpty {
            DisclosureGroup(isExpanded: expansionBinding(for: group.company)) {
                ForEach(filteredRoutes(group.routes)) { route in
                    row(for: route)
                }
            } label: {
                companyLabel(group.company)
            }
        }
    }
    
    private func row(for route: Route) -> some View {
        Button {
            selection = route
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                RouteRow(route: route)
                Spacer()
                if selection == route {
                    Image(systemName: "checkmark")
                        .font(.largeHeadline)
                }
            }
        }
        .macCustomButton()
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
        .font(.largeHeadline, weight: .medium)
    }
    
    private func expansionBinding(for company: Company, default: Bool = true) -> Binding<Bool> {
        Binding {
            companyState[company, default: `default`] || selection?.company == company
        } set: { _,_ in
            companyState[company] = !companyState[company, default: `default`]
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
