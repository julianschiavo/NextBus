//
//  Token.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Token: Identifiable {
    var id: String { text }
    
    var color: Color
    var imageName: String
    var text: String
    
//    var image: UIImage {
//        UIImage(systemName: imageName) ?? UIImage(named: imageName) ?? UIImage()
//    }
    
    // MARK: - Presets
    
    static func tokens(route: Route, stop: Stop? = nil) -> [Token] {
        var tokens = [Token]()
//        if let fare = route.fare ?? stop?.normalFare {
//            tokens.append(.price(fare))
//        }
//        if route.isSpecial || stop?.specialDeparturesOnly == true {
//            tokens.append(.special)
//        }
//        if route.isOvernight || route.name.first == "N" {
//            tokens.append(.overnight)
//        }
        return tokens
    }
    
    static func price(_ price: String) -> Token {
        Token(color: .green, imageName: "dollarsign.circle", text: "$" + price)
    }
    
    static let special = Token(color: .red, imageName: "star", text: "SPECIAL")
    static let overnight = Token(color: .purple, imageName: "moon.stars", text: "OVERNIGHT")
}
