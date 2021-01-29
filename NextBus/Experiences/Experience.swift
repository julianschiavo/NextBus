//
//  Experience.swift
//  Clip
//
//  Created by Julian Schiavo on 13/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

enum Experience: Identifiable {
    case list
    case status(StatusExperience)
    
    var id: String {
        switch self {
        case .list: return "list"
        case .status: return "status"
        }
    }
}

struct StatusExperience {
    let company: Company
    let routeID: String
    let stopID: String?
    
    private static let baseURL = URL(string: "https://appclip.schiavo.me/status")!
    
    func toURL() -> URL? {
        guard var components = URLComponents(url: StatusExperience.baseURL, resolvingAgainstBaseURL: true) else { return nil }
        components.path = "/status"
        components.queryItems = [
            URLQueryItem(name: "p", value: company.rawValue),
            URLQueryItem(name: "p1", value: routeID)
        ]
        if let stopID = stopID {
            components.queryItems?.append(URLQueryItem(name: "p2", value: stopID))
        }
        return components.url
    }
}
