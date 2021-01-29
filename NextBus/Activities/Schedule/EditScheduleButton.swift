//
//  EditScheduleButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct EditScheduleButton: View {
    var present: () -> Void
    
    var body: some View {
        Button(action: present) {
            Label("Edit Schedule", systemImage: "pencil")
        }
    }
}
