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

@main
struct Widget: WidgetBundle {
    init() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @WidgetBundleBuilder var body: some SwiftUI.Widget {
        ArrivalTimeWidget()
    }
}
