//
//  DeleteScheduleButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct DeleteScheduleButton: View {
    @EnvironmentObject private var store: Store
    @Environment(\.dismiss) private var dismiss
    
    let block: ScheduleBlock
    
    var body: some View {
        Group {
            Menu {
                Button(role: .destructive, action: delete) {
                    Label(Localizable.delete, systemImage: "trash.fill")
                }
            } label: {
                Label(Localizable.Schedule.delete, systemImage: "trash.fill")
            }
        }
    }
    
    func delete() {
        dismiss()
        store.schedule.delete(block)
    }
}
