//
//  Experience.swift
//  Clip
//
//  Created by Julian Schiavo on 13/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

private extension Array where Element == URLQueryItem {
    func named(_ name: String) -> Element? {
        first { $0.name == name }
    }
}

enum Experience: Identifiable {
    case list
    case status(company: Company, routeID: String, stopID: String?)
    
    private static let baseURL = URL(string: "https://appclip.schiavo.me/status")!
    
    var id: String {
        switch self {
        case .list: return "list"
        case .status: return "status"
        }
    }
    
    static func `for`(url: URL) -> Self? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let type = components.path.split(separator: "/").first
        else { return nil }
        
        guard type != "list" else {
            return .list
        }

        guard let queryItems = components.queryItems,
              let identifier = queryItems.first?.value
        else { return nil }
        
        switch type {
        case "status":
            guard let company = Company(rawValue: identifier),
                  let routeID = queryItems.named("p1")?.value
            else { return nil }
            let stopID = queryItems.named("p2")?.value
            
            return .status(company: company, routeID: routeID, stopID: stopID)
        default:
            return nil
        }
    }
    
    func toURL() -> URL? {
        guard case let .status(company, routeID, stopID) = self,
              var components = URLComponents(url: Self.baseURL, resolvingAgainstBaseURL: true)
        else { return nil }
        
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
