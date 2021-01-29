//
//  StopPicker.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct StopPicker: View, Loadable {
    @Environment(\.presentationMode) private var presentationMode
    
    let route: Route
    @Binding var selection: Stop?
    
    var key: Route { route }
    
    @StateObject var loader = RouteStopsLoader()
    
    var body: some View {
        NavigationView {
            loaderView
                .macMinFrame(width: 700, height: 500)
                .navigationTitle("Select Stop")
                .navigationTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .confirmationAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
            presentationMode.wrappedValue.dismiss()
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
        ProgressView("Loading Stops...")
            .padding(10)
            .aligned(to: .center)
    }
}
