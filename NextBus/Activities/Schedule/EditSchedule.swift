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
    
    @Environment(\.dismiss) private var dismiss
    
    let block: ScheduleBlock
    
    @State private var name = ""
    
    @State private var routeStops = [RouteStop]()
    @State private var newRouteStop: RouteStop?
    
    @State private var days = [String]()
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var showsOnWidget = true
    @State private var sendsNotifications = false
    
    @State private var sheet: Sheet?
    
    init(_ schedule: ScheduleBlock) {
        self.block = schedule
        _name = State(initialValue: schedule.name)
        _routeStops = State(initialValue: schedule.routeStops)
        _days = State(initialValue: schedule.days ?? [])
        _startDate = State(initialValue: schedule.startDate)
        _endDate = State(initialValue: schedule.endDate)
        _showsOnWidget = State(initialValue: schedule.showsOnWidget)
        _sendsNotifications = State(initialValue: schedule.sendsNotifications)
    }
    
    var body: some View {
        iOSNavigationView {
            Form {
                mainSection
                routesSection
                timeSection
                settingsSection
                deleteSection
            }
            .navigationTitle(Localizable.Schedule.edit)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button(Localizable.cancel) {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button(Localizable.save, action: save)
                        .disabled(name.isEmpty || routeStops.isEmpty)
                }
            }
            .macMinFrame(width: 700, height: 600)
            .globalSheet($sheet)
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
                .font(.title3, weight: .medium)
        }
    }
    
    @ViewBuilder private var routesSection: some View {
        ForEach($routeStops) { $routeStop in
            Section {
                ScheduleRoutePicker(routeStop: Binding($routeStop), sheet: $sheet) {
                    routeStops.removeAll { $0.id == $routeStop.wrappedValue.id }
                }
            }
        }
        Section(header: Text(Localizable.selectRoute)) {
            ScheduleRoutePicker(routeStop: $newRouteStop, sheet: $sheet)
                .onChange(of: newRouteStop) { newRouteStop in
                    guard let newRouteStop = newRouteStop else { return }
                    routeStops.append(newRouteStop)
                    self.newRouteStop = nil
                }
        }
    }
    
    private var timeSection: some View {
        Section(header: Text(Localizable.time)) {
            DaysPicker(days: $days)
                .buttonStyle(.plain)
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
    
    private var deleteSection: some View {
        Section {
            DeleteScheduleButton(block: block)
        }
    }
    
    private func save() {
        var schedule = ScheduleBlock(name: name, days: days, startDate: startDate, endDate: endDate, routeStops: routeStops, showsOnWidget: showsOnWidget, sendsNotifications: sendsNotifications)
        schedule.id = self.block.id
        store.schedule.update(schedule)
        dismiss()
    }
}
