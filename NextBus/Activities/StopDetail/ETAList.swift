//
//  ETAList.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ETAList: View, Loadable {
    let route: Route
    let stop: Stop
    
    @Binding var reload: Bool
    
    var key: RouteStop { RouteStop(route: route, stop: stop) }
    
    @StateObject var loader = ETALoader()
    
    var body: some View {
        loaderView
    }
    
    func body(with etas: [ETA]) -> some View {
        VStack(spacing: 0) {
            ForEach(etas) { eta in
                ETARow(eta: eta)
                Divider()
            }
            if etas.isEmpty {
                error
            }
            if let last = etas.last {
                LastUpdatedText(date: last.generated)
            }
        }
        .background(Color.tertiaryBackground)
        .onChange(of: reload) { _ in
            loader.load(key: key)
        }
    }
    
    private var error: some View {
        Label(Localizations.errorArrivalInformationNotAvailable, systemImage: "exclamationmark.triangle.fill")
            .foregroundColor(.red)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
    }
    
    func placeholder() -> some View {
        ProgressView()
    }
}
