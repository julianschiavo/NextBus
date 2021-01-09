//
//  HasPlaceholder.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

protocol HasPlaceholder: View {
    associatedtype Placeholder: View
    static var placeholder: Placeholder { get }
}

