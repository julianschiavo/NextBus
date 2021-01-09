//
//  Switch-ArrayMatch.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

func ~=<T: Equatable>(pattern: [T], value: T) -> Bool {
    return pattern.contains(value)
}

func ~=<T: Equatable>(pattern: Set<T>, value: T) -> Bool {
    return pattern.contains(value)
}
