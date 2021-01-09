//
//  CustomAssistedError.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

struct CustomAssistedError: AssistedError, Equatable {
    let title: String
    var description: String?
    var recoverySuggestion: String?
}
