//
//  LocalizedText.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

typealias Localizable = L10n.Localizable

enum LanguageCode: CaseIterable {
    case english
    case simplifiedChinese
    case traditionalChinese
    
    var identifiers: [String] {
        switch self {
        case .english: return ["en"]
        case .simplifiedChinese: return ["zh-Hans", "zh-Hans-CN", "zh-Hans-SG", "zh-Hans-MO", "zh-Hans-HK"]
        case .traditionalChinese: return ["zh-Hant", "zh-Hant-TW", "zh-Hant-MO", "zh-Hant-HK", "zh-Hant-CN", "zh-HK"]
        }
    }
    
    static var current: LanguageCode {
        let code = Locale.preferredLanguages.first ?? ""
        return allCases.first { $0.identifiers.contains(code) } ?? .english
    }
}

struct LocalizedText: Codable, Equatable, Hashable {
    var english: String
    var simplifiedChinese: String
    var traditionalChinese: String
    
    init(_ string: String) {
        self.english = string
        self.simplifiedChinese = string
        self.traditionalChinese = string
    }
    
    init(en english: String, sc simplifiedChinese: String, tc traditionalChinese: String) {
        self.english = english
        self.simplifiedChinese = simplifiedChinese
        self.traditionalChinese = traditionalChinese
    }
    
    var current: String {
        switch LanguageCode.current {
        case .english:
            return english
        case .simplifiedChinese:
            return simplifiedChinese
        case .traditionalChinese:
            return traditionalChinese
        }
    }
    
    static var directionsLanguageCode: String {
        switch LanguageCode.current {
        case .english:
            return "EN"
        case .simplifiedChinese:
            return "SC"
        case .traditionalChinese:
            return "TC"
        }
    }
    
    static var kmbLanguageCode: String {
        switch LanguageCode.current {
        case .english:
            return "en"
        case .simplifiedChinese:
            return "sc"
        case .traditionalChinese:
            return "tc"
        }
    }
    
    static var nlbLanguageCode: String {
        switch LanguageCode.current {
        case .english:
            return "en"
        case .simplifiedChinese:
            return "cn"
        case .traditionalChinese:
            return "zh"
        }
    }
}
