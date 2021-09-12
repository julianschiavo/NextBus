//
//  StopPicker.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Loadability
import SwiftUI

struct StopPicker: View, LoadableView {
    @Environment(\.dismiss) private var dismiss
    
    let route: Route
    @Binding var selection: Stop?
    
    var key: Route { route }
    
    @StateObject var loader = RouteStopsLoader()
    
    var body: some View {
        NavigationView {
            loaderView
                .macMinFrame(width: 700, height: 500)
                .navigationTitle(Localizable.selectStop)
                .navigationTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .confirmationAction) {
                        Button(Localizable.done) {
                            dismiss()
                        }
                    }
                }
        }
        .navigationViewStyle(.stacks)
    }
    
    func body(with stops: [Stop]) -> some View {
        List {
            ForEach(stops) { stop in
                row(for: stop)
            }
        }
    }
    
    private func row(for stop: Stop) -> some View {
        Button {
            selection = stop
            dismiss()
        } label: {
            HStack {
                StopRow(route: route, stop: stop)
                Spacer()
                if selection == stop {
                    Image(systemName: "checkmark")
                        .font(.largeHeadline)
                }
            }
        }
        .macCustomButton()
    }
    
    func placeholder() -> some View {
        ProgressView(Localizable.loadingStops)
            .padding(10)
            .aligned(to: .center)
    }
}
