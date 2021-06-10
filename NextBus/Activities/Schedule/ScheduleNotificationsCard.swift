//
//  ScheduleNotificationsCard.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ScheduleNotificationsCard: View {
    
    @ObservedObject var notificationsBuddy = NotificationsBuddy()
    
    var body: some View {
        Card {
            Button {
                notificationsBuddy.requestAuthorization()
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text(Localizable.Schedule.enableNotificationsTitle)
                        Text(Localizable.Schedule.enableNotificationsDescription)
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
