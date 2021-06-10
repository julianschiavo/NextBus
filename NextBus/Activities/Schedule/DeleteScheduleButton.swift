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
    @Environment(\.presentationMode) private var presentationMode
    
    let block: ScheduleBlock
    
    var body: some View {
        Group {
            Menu {
                Button(action: delete) {
                    Label(Localizable.delete, systemImage: "trash.fill")
                        .foregroundColor(.red)
                }
            } label: {
                Label(Localizable.Schedule.delete, systemImage: "trash.fill")
                    .foregroundColor(.red)
            }
        }
    }
    
    func delete() {
        presentationMode.wrappedValue.dismiss()
        store.schedule.delete(block)
    }
}
