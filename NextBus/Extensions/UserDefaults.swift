//
//  UserDefaults.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let shared = UserDefaults(suiteName: "group.com.julianschiavo.nextbus")!
}

@propertyWrapper struct UserDefault<Value: Codable> {
    let key: String
    let `default`: Value
    
    init(key: String, `default`: Value) {
        self.key = key
        self.default = `default`
    }
    
    var wrappedValue: Value {
        get {
            return UserDefaults.shared.object(forKey: key) as? Value ?? `default`
        }
        set {
            UserDefaults.shared.set(newValue, forKey: key)
        }
    }
}
