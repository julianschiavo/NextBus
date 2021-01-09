//
//  StopCell.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 9/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct StopCell: View {
    
    let route: Route
    let direction: Direction
    let stop: Stop
    
    var body: some View {
        let font = Font.body.monospacedDigit()
        
        var text: Text
        if let index = stop.index {
            let indexText = Text("\(index): ").bold()
            let stopNameText = Text(stop.localizedName)
            let joinedText = indexText + stopNameText
            text = joinedText.font(font)
        } else {
            text = Text(stop.localizedName).font(font)
        }
        
        return NavigationLink(destination: RouteDetailView(route: route, direction: direction, stop: stop)) {
            text
        }
    }
}
