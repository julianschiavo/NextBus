//
//  ScheduleNotificationsDisabledCard.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ScheduleNotificationsDisabledCard: View {
    var body: some View {
        Card {
            Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                Label {
                    VStack(alignment: .leading) {
                        Text(Localizable.Schedule.notificationsDisabledTitle)
                        Text(Localizable.Schedule.notificationsDisabledDescription)
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
