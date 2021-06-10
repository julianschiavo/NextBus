//
//  ArrivalTimeWidget.swift
//  Clip
//
//  Created by Julian Schiavo on 13/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ArrivalTimeWidget: SwiftUI.Widget {
    let kind: String = "ArrivalTimeWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectRouteStopIntent.self, provider: ArrivalTimeProvider()) { entry in
            ArrivalTimeView(entry: entry)
        }
        .configurationDisplayName(Localizable.Widgets.ArrivalTime.name)
        .description("")
    }
}
