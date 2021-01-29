//
//  ScheduleList.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ScheduleList: View {
    @EnvironmentObject private var store: Store
    
    @Binding var sheet: Sheet?
    
    var body: some View {
        if store.schedule.all.isEmpty {
            placeholder
        } else {
            list
        }
    }
    
    private var list: some View {
        ForEach(store.schedule.all) { block in
            ScheduleRow(block: block, sheet: $sheet)
        }
        .onDelete { offsets in
            store.schedule.delete(at: offsets)
        }
    }
    
    private var placeholder: some View {
        Card {
            Button {
                sheet = .newSchedule(route: nil, stop: nil)
            } label: {
                Label("Add Schedule", systemImage: "plus")
                    .font(.headline, weight: .semibold)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.secondaryBackground)
            }
            .macCustomButton()
        }
    }
}
