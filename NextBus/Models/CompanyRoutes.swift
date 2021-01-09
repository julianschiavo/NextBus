//
//  CompanyRoutes.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

struct CompanyRoutes: Identifiable {
    var id: CompanyID { company }
    var company: CompanyID
    var routes: [Route]
}
