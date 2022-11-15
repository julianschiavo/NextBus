//
//  ScheduleRoutePicker.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/10/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ScheduleRoutePicker: View {
    @Binding var routeStop: RouteStop?
    @Binding var sheet: Sheet?
    let delete: (() -> Void)?
    
    @State private var route: Route?
    @State private var stop: Stop?
    
    init(routeStop: Binding<RouteStop?>, sheet: Binding<Sheet?>, delete: (() -> Void)? = nil) {
        self._routeStop = routeStop
        self._sheet = sheet
        self._route = State(initialValue: routeStop.wrappedValue?.route)
        self._stop = State(initialValue: routeStop.wrappedValue?.stop)
        self.delete = delete
    }
    
    var body: some View {
        Group {
            routePicker
            if route != nil {
                stopPicker
            }
            if delete != nil {
                deleteButton
            }
        }
        .onChange(of: routeStop) { routeStop in
            guard routeStop == nil else { return }
            route = nil
            stop = nil
        }
        .onChange(of: route) { route in
            stop = nil
        }
        .onChange(of: stop) { stop in
            guard let route = route, let stop = stop else { return }
            routeStop = RouteStop(route: route, stop: stop)
        }
    }
    
    @ViewBuilder private var routePicker: some View {
        if let route = route {
            HStack {
                RouteRow(route: route)
                Spacer()
                changeRouteButton
            }
        } else {
            selectRouteButton
        }
    }
    
    private var selectRouteButton: some View {
        Button {
            sheet = .pickRoute(route: $route)
        } label: {
            HStack {
                Text(Localizable.route)
                    .foregroundColor(.primary)
                Spacer()
                Text(Localizable.choose)
            }
        }
        .macCustomButton()
    }
    
    private var changeRouteButton: some View {
        Button {
            sheet = .pickRoute(route: $route)
        } label: {
            Text(Localizable.change)
                .padding(6)
                .background(Color.quaternaryBackground)
                .cornerRadius(6)
        }
        .macCustomButton()
    }
    
    @ViewBuilder private var stopPicker: some View {
        if let route = route, let stop = stop {
            HStack {
                StopRow(route: route, stop: stop)
                Spacer()
                changeStopButton
            }
        } else {
            chooseStopButton
        }
    }
    
    private var chooseStopButton: some View {
        Button {
            if let route = route {
                sheet = .pickStop(route: route, stop: $stop)
            }
        } label: {
            HStack {
                Text(Localizable.stop)
                    .foregroundColor(.primary)
                Spacer()
                Text(Localizable.choose)
            }
        }
        .macCustomButton()
    }
    
    private var changeStopButton: some View {
        Button {
            if let route = route {
                sheet = .pickStop(route: route, stop: $stop)
            }
        } label: {
            Text(Localizable.change)
                .padding(6)
                .background(Color.quaternaryBackground)
                .cornerRadius(6)
        }
        .macCustomButton()
    }
    
    private var deleteButton: some View {
        Button {
            delete?()
        } label: {
            Label(Localizable.delete, systemImage: "trash.fill")
        }
    }
}
