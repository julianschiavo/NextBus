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
    @StateObject private var payBuddy = PayBuddy()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    ScheduleInfoCard()
                    upgradeRequiredCard
                    notificationsSuggestionCard
                    notificationsDisabledCard
                    ScheduleList(sheet: $sheet)
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 15)
            }
            .macMinFrame(width: 260)
            .macMaxFrame(width: 500)
            .alert(errorBinding: $notificationsBuddy.error)
            .navigationTitle(Localizable.Schedule.name)
            .toolbar {
                ToolbarItemGroup {
                    NewScheduleToolbarButton(sheet: $sheet)
                }
            }
            .globalSheet($sheet)
        }
        .environmentObject(payBuddy)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var infoCard: some View {
        ScheduleInfoCard()
    }
    
    @ViewBuilder private var upgradeRequiredCard: some View {
        if !payBuddy.hasPlus {
            UpgradeRequiredCard(sheet: $sheet)
        }
    }
    
    @ViewBuilder private var notificationsSuggestionCard: some View {
        if !notificationsBuddy.hasAuthorization, !notificationsBuddy.didRequestAuthorization, payBuddy.hasPlus {
            ScheduleNotificationsCard(notificationsBuddy: notificationsBuddy)
        }
    }
    
    @ViewBuilder private var notificationsDisabledCard: some View {
        if !notificationsBuddy.hasAuthorization, notificationsBuddy.didRequestAuthorization, payBuddy.hasPlus {
            ScheduleNotificationsDisabledCard()
        }
    }
}
