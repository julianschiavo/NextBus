//
//  SimpleBusInfoView.swift
//  NextBus
//
//  Created by Julian Schiavo on 17/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

class SimpleBusInfo: ObservableObject {
    @Published var route: Route?
    @Published var stop: Stop?
}

struct SimpleBusInfoView: View {
    @ObservedObject var info: SimpleBusInfo
    
    @State private var reload = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if let route = info.route, let stop = info.stop {
                StopDetailHeader(route: route, stop: stop)
                    .padding(8)
                Card {
                    ETAList(route: route, stop: stop, reload: $reload)
                }
            } else {
                ProgressView(Localizable.loadingRoute)
            }
        }
        .padding(20)
//        .frame(height: 300)
        .onChange(of: reload) { _ in
            return
        }
        .onReceive(timer) { _ in
            reloadWithAnimation()
        }
    }
    
    private func reloadWithAnimation() {
        withAnimation {
            reload.toggle()
        }
    }
}

