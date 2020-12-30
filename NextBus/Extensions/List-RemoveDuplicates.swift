//
//  List-RemoveDuplicates.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    mutating func removeDuplicates() {
        self = reduce(into: [Element]()) { newArray, item in
            let contained = newArray.contains { $0.id == item.id }
            if !contained { newArray.append(item) }
        }
    }
    
    func removingDuplicates() -> [Element] {
        var copy = self
        copy.removeDuplicates()
        return copy
    }
}
