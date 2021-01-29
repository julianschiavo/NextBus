//
//  EditSchedule.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct EditSchedule: View {
    @EnvironmentObject private var store: Store
    
    @Environment(\.presentationMode) private var presentationMode
    
    let block: ScheduleBlock
    
    @State private var name = ""
    
    @State private var route: Route?
    @State private var stop: Stop?
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var showsOnWidget = true
    @State private var sendsNotifications = false
    
    @State private var sheet: Sheet?
    
    init(_ schedule: ScheduleBlock) {
        self.block = schedule
        _name = State(initialValue: schedule.name)
        _route = State(initialValue: schedule.route)
        _stop = State(initialValue: schedule.stop)
        _startDate = State(initialValue: schedule.startDate)
        _endDate = State(initialValue: schedule.endDate)
        _showsOnWidget = State(initialValue: schedule.showsOnWidget)
        _sendsNotifications = State(initialValue: schedule.sendsNotifications)
    }
    
    var body: some View {
        NavigationView {
            Form {
                mainSection
                timeSection
                settingsSection
                deleteSection
            }
            .navigationTitle("Edit Schedule")
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Save", action: save)
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
            TextField("Name", text: $name)
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
                Text("Route")
                    .foregroundColor(.primary)
                Spacer()
                Text("Choose")
            }
        }
        .macCustomButton()
    }
    
    private var changeRouteButton: some View {
        Button {
            sheet = .pickRoute(route: $route)
        } label: {
            Text("Change")
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
                Text("Stop")
                    .foregroundColor(.primary)
                Spacer()
                Text("Choose")
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
            Text("Change")
                .padding(6)
                .background(Color.quaternaryBackground)
                .cornerRadius(6)
        }
        .macCustomButton()
    }
    
    private var timeSection: some View {
        Section(header: Text("Time")) {
            HStack {
                Text("Starts")
                Spacer()
                DatePicker("", selection: $startDate, displayedComponents: .hourAndMinute)
            }
            HStack {
                Text("Ends")
                Spacer()
                DatePicker("", selection: $endDate, displayedComponents: .hourAndMinute)
            }
        }
        .datePickerStyle(GraphicalDatePickerStyle())
    }
    
    private var settingsSection: some View {
        Section(header: Text("Settings")) {
            //            Toggle("Show on Schedule Widget", isOn: $showsOnWidget)
            Toggle("Arrival Time Notifications", isOn: $sendsNotifications)
        }
    }
    
    private var deleteSection: some View {
        Section {
            DeleteScheduleButton(block: block)
        }
    }
    
    private func save() {
        guard let route = route, let stop = stop else { return }
        var schedule = ScheduleBlock(name: name, startDate: startDate, endDate: endDate, route: route, stop: stop, showsOnWidget: showsOnWidget, sendsNotifications: sendsNotifications)
        schedule.id = self.block.id
        store.schedule.update(schedule)
        presentationMode.wrappedValue.dismiss()
    }
}
