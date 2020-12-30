//
//  RouteDataManager.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 8/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

class RouteDataManager: ObservableObject {
    
    @Published var routes = [Route]()
    @Published var error: Error?
    
    func reloadData() {
        APIManager.shared.updateData(priority: .normal) { error in
            self.error = error
            self.updateData()
        }
    }
    
    func updateData() {
        routes = []
        for company in APIManager.shared.cachedCompanies {
            guard let companyRoutes = APIManager.shared.routes(for: company.id)?.contents else { return }
            routes.append(contentsOf: companyRoutes)
        }
        routes = routes.sorted { $0.name < $1.name }
    }
    
    // MARK: Singleton
    
    static let shared = RouteDataManager()
    
    private init() {
        updateData()
        reloadData()
    }
}
