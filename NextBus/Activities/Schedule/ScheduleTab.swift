//
//  ScheduleTab.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ScheduleTab: View {
    @State private var sheet: Sheet?
    
    @StateObject private var notificationsBuddy = NotificationsBuddy()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    infoCard
                    notificationsSuggestionCard
                    notificationsDisabledCard
                    ScheduleList(sheet: $sheet)
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 15)
            }
            .macMinFrame(width: 260)
            .alert(errorBinding: $notificationsBuddy.error)
            .navigationTitle("Schedule")
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        sheet = .newSchedule(route: nil, stop: nil)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .globalSheet($sheet)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var infoCard: some View {
        Card {
            Text("Create Schedules to quickly see your daily routes on Dashboard and receive notifications with bus arrival times.")
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .layoutPriority(1)
                .background(Color.secondaryBackground)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .layoutPriority(1)
    }
    
    @ViewBuilder private var notificationsSuggestionCard: some View {
        if !notificationsBuddy.hasAuthorization, !notificationsBuddy.didRequestAuthorization {
            Card {
                Button {
                    notificationsBuddy.requestAuthorization()
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text("Enable Notifications")
                            Text("Receive notifications with the latest bus arrival time when schedules start.")
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    } icon: {
                        Image(systemName: "app.badge.fill")
                    }
                    .font(.largeHeadline)
                    .alignedHorizontally(to: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.secondaryBackground)
                }
                .macCustomButton()
            }
        }
    }
    
    @ViewBuilder private var notificationsDisabledCard: some View {
        if !notificationsBuddy.hasAuthorization, notificationsBuddy.didRequestAuthorization {
            Card {
                Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                    Label {
                        VStack(alignment: .leading) {
                            Text("Notifications Disabled")
                            Text("You will not receive notifications when schedules start.")
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .font(.largeHeadline)
                    .foregroundColor(.red)
                    .alignedHorizontally(to: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.secondaryBackground)
                }
                .macCustomButton()
            }
        }
    }
}
