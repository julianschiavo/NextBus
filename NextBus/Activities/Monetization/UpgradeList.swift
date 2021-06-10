//
//  UpgradeList.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct UpgradeList: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .labelText, spacing: 20) {
                UpgradeListItem(title: Localizable.Upgrade.Widgets.title,
                                description: Localizable.Upgrade.Widgets.description,
                                systemImage: "square.stack.fill")
                UpgradeListItem(title: Localizable.Upgrade.Schedule.title,
                                description: Localizable.Upgrade.Schedule.description,
                                systemImage: "calendar")
                UpgradeListItem(title: Localizable.Upgrade.Notifications.title,
                                description: Localizable.Upgrade.Notifications.description,
                                systemImage: "app.badge.fill")
                UpgradeListItem(title: Localizable.Upgrade.Support.title,
                                description: Localizable.Upgrade.Support.description,
                                systemImage: "person.fill")
            }
        }
    }
}
