//
//  NewSchedule.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct NewSchedule: View {
    @EnvironmentObject private var store: Store
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    
    @State private var route: Route?
    @State private var stop: Stop?
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var showsOnWidget = true
    @State private var sendsNotifications = false
    
    @State private var sheet: Sheet?
    
    init(route: Route? = nil, stop: Stop? = nil) {
        _route = State(initialValue: route)
        _stop = State(initialValue: stop)
    }
    
    var body: some View {
        iOSNavigationView {
            Form {
                mainSection
                timeSection
                settingsSection
            }
            .navigationTitle(Localizable.Schedule.new)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button(Localizable.cancel) {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button(Localizable.create, action: create)
                        .disabled(name.isEmpty || route == nil || stop == nil)
                }
            }
            .macMinFrame(width: 700, height: 600)
            .globalSheet($sheet)
        }
        .onChange(of: route) { _ in
            stop = nil
        }
        .onChange(of: startDate) { startDate in
            if endDate <= startDate {
                endDate = startDate.addingTimeInterval(60)
            }
        }
    }
    
    private var mainSection: some View {
        Section {
            TextField(Localizable.name, text: $name)
            routePicker
            if route != nil {
                stopPicker
            }
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
                Text("CHOOSE")
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
    
    private var timeSection: some View {
        Section(header: Text(Localizable.time)) {
            HStack {
                Text(Localizable.starts)
                Spacer()
                DatePicker("", selection: $startDate, displayedComponents: .hourAndMinute)
            }
            HStack {
                Text(Localizable.ends)
                Spacer()
                DatePicker("", selection: $endDate, displayedComponents: .hourAndMinute)
            }
        }
        .datePickerStyle(.graphical)
    }
    
    private var settingsSection: some View {
        Section(header: Text(Localizable.settings)) {
//            Toggle("Show on Schedule Widget", isOn: $showsOnWidget)
            Toggle(Localizable.Schedule.arrivalTimeNotifications, isOn: $sendsNotifications)
        }
    }
    
    private func create() {
        guard let route = route, let stop = stop else { return }
        let schedule = ScheduleBlock(name: name, startDate: startDate, endDate: endDate, route: route, stop: stop, showsOnWidget: showsOnWidget, sendsNotifications: sendsNotifications)
        store.schedule.add(schedule)
        dismiss()
    }
}
