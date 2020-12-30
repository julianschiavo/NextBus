//
//  Company.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let favoritesChanged = Notification.Name("FavoritesChanged")
    static let companyIsShownChanged = Notification.Name("CompanyIsShownChanged")
}

enum CompanyID: String, CaseIterable, Codable {
    case ctb = "CTB"
    case nlb = "NLB"
    case nwfb = "NWFB"
    
    static let nwfbctbIDs: [CompanyID] = [.ctb, .nwfb]
    static var nlbIDs: [CompanyID] = [.nlb]
}

struct Company: Hashable, Codable, Identifiable {

    var id: CompanyID
    
    var generated: Date
    
    var name: String {
        LocalizedText(en: englishName, sc: simplifiedChineseName, tc: traditionalChineseName).current
    }
    var englishName: String
    var simplifiedChineseName: String
    var traditionalChineseName: String
    
    var isShown: Bool {
        return !isHidden
    }
    
    private var isHidden: Bool {
//        guard UserDefaults.shared.data(forKey: "\(id)Shown") != nil else { return true }
        return UserDefaults.shared.bool(forKey: "\(id)Hidden")
    }
    
    func setIsShown(_ shown: Bool) {
        setIsHidden(!shown)
    }
    
    private func setIsHidden(_ hidden: Bool) {
        UserDefaults.shared.set(hidden, forKey: "\(id)Hidden")
        NotificationCenter.default.post(Notification(name: .companyIsShownChanged))
    }
}
