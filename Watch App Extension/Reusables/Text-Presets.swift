//
//  Title.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

extension Text {
    func title() -> Text {
        self
            .font(.headline)
    }
    
    func subtitle() -> Text {
        self
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}
