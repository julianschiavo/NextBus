//
//  Widget.swift
//  Widget
//
//  Created by Julian Schiavo on 13/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import Purchases

@main
struct Widget: WidgetBundle {
    init() {
        WidgetCenter.shared.reloadAllTimelines()
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "bKFVCyRdhomurfBWXgxdRbZOsjkkGjlF", appUserID: nil, observerMode: false, userDefaults: .shared)
    }
    
    @WidgetBundleBuilder var body: some SwiftUI.Widget {
        ArrivalTimeWidget()
    }
}
