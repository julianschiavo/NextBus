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
    @State private var filteredCompanyState = [Company: Bool]()
    
    var body: some View {
        loaderView
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("FUVFUFUDFUF") {
                        
                    }
                }
            }
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
        .listStyle(.sidebar)
        .searchable(text: $searchText, prompt: Localizable.search)
        .onChange(of: searchText) { _ in
            Task {
                await updateRoutes()
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("FUVFUFUDFUF") {
                    
                }
            }
//            ToolbarItemGroup(placement: .keyboard) {
//                ForEach(["A", "B", "M", "N", "P", "R", "S", "X"], id: \.self) { letter in
//                    Button(letter) {
//                        searchText.append(letter)
//                    }
//                }
//            }
        }
        .task {
            await updateRoutes()
        }
//        .navigationBarSearch($searchText) {
//            RouteSearchToolbar(searchText: $searchText)
//        }
    }
    
    private func sectionList(for group: CompanyRoutes) -> some View {
        DisclosureGroup(isExpanded: expansionBinding(for: group.company)) {
            ForEach(group.routes) { route in
                NavigationLink(destination: BusDetail(route: route)) {
                    RouteRow(route: route)
                }
            }
        } label: {
            companyLabel(group.company)
        }
        .tint(group.company.color)
    }
    
    @ViewBuilder private func filteredList(for group: CompanyRoutes) -> some View {
        if let routes = loader.filteredRoutes[group.company], !routes.isEmpty {
            DisclosureGroup(isExpanded: filteredExpansionBinding(for: group.company)) {
                ForEach(routes) { route in
                    NavigationLink(destination: BusDetail(route: route)) {
                        RouteRow(route: route)
                    }
                }
            } label: {
                companyLabel(group.company)
            }
            .tint(group.company.color)
        }
    }
    
    private func companyLabel(_ company: Company) -> some View {
        Button {
            withAnimation {
                companyState[company] = !companyState[company, default: false]
            }
        } label: {
            Label(
                title: {
                    Text(company.name)
                },
                icon: {
                    Image(systemName: company.category.iconName)
                        .foregroundColor(company.color)
                }
            )
            .tint(company.color)
            .font(.largeHeadline, weight: .medium)
        }
        .buttonStyle(.plain)
    }
    
    private func expansionBinding(for company: Company) -> Binding<Bool> {
        Binding {
            companyState[company, default: false]
        } set: { _, _ in
            companyState[company] = !companyState[company, default: false]
        }
    }
    
    private func filteredExpansionBinding(for company: Company) -> Binding<Bool> {
        Binding {
            filteredCompanyState[company, default: true]
        } set: { _, _ in
            filteredCompanyState[company] = !filteredCompanyState[company, default: true]
        }
    }
    
    private func updateRoutes() async {
        guard let companyRoutes = loader.object else { return }
        await withTaskGroup(of: Void.self) { group in
            for cGroup in companyRoutes {
                group.async {
                    let routes = await searchText.isEmpty ? cGroup.routes : filteredRoutes(cGroup.routes)
                    DispatchQueue.main.async {
                        self.loader.filteredRoutes[cGroup.company] = routes
                    }
                }
            }
        }
    }
    
    private func filteredRoutes(_ routes: [Route]) async -> [Route] {
        routes.filter {
            $0.localizedName.lowercased().hasPrefix(searchText.lowercased())
        }
    }
    
    func placeholder() -> some View {
        ProgressView(Localizable.loadingRoutes)
    }
}
