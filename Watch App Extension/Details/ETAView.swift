//
//  ETAView.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ETAView: View {
    
    let eta: ETA
    
    @State private var shouldReload = false
    
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let relativeFormatter = RelativeDateTimeFormatter()
    private let dateFormatter = DateFormatter()
    
    init(eta: ETA) {
        self.eta = eta
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
    }
    
    var body: some View {
        var title: Text
        let description = Text(eta.localizedRemark).font(.subheadline).foregroundColor(.secondary)
        
        if let date = eta.date, let formattedDate = dateFormatter.string(for: date), let relativeDate = relativeFormatter.string(for: date) {
            title = Text("\(formattedDate) (\(relativeDate))")
        } else {
            title = Text(Localizations.errorArrivalInformationNotAvailable)
                .title()
        }
        
        return VStack {
            title
            if !eta.localizedRemark.isEmpty { description }
        }
        .padding([.top, .bottom])
        .onReceive(timer) { _ in self.shouldReload.toggle() }
    }
}
