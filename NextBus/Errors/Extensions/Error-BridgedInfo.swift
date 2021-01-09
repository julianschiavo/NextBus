//
//  Error-BridgedInfo.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

extension Error {
    var nsError: NSError {
        self as NSError
    }
    
    /// The error code
    var code: Int {
        nsError.code
    }
    
    /// The error domain
    var domain: String {
        nsError.domain
    }
}
