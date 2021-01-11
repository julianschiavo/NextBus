//
//  LocalizedText.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

enum LanguageCode: String {
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
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
        guard let preferredLanguage = Locale.preferredLanguages.first else { return english }
        let simplifiedChineseCode = LanguageCode.simplifiedChinese.rawValue
        let traditionalChineseCode = LanguageCode.traditionalChinese.rawValue
        
        if preferredLanguage.contains(simplifiedChineseCode) {
            return simplifiedChinese
        } else if preferredLanguage.contains(traditionalChineseCode) {
            return traditionalChinese
        } else {
            return english
        }
    }
    
    static var kmbLanguageCode: String {
        guard let preferredLanguage = Locale.preferredLanguages.first else { return "en" }
        let simplifiedChineseCode = LanguageCode.simplifiedChinese.rawValue
        let traditionalChineseCode = LanguageCode.traditionalChinese.rawValue
        
        if preferredLanguage.contains(simplifiedChineseCode) {
            return "sc"
        } else if preferredLanguage.contains(traditionalChineseCode) {
            return "tc"
        } else {
            return "en"
        }
    }
    
    static var nlbLanguageCode: String {
        guard let preferredLanguage = Locale.preferredLanguages.first else { return "en" }
        let simplifiedChineseCode = LanguageCode.simplifiedChinese.rawValue
        let traditionalChineseCode = LanguageCode.traditionalChinese.rawValue
        
        if preferredLanguage.contains(simplifiedChineseCode) {
            return "cn"
        } else if preferredLanguage.contains(traditionalChineseCode) {
            return "zh"
        } else {
            return "en"
        }
    }
}
