//
//  InvocationError.swift
//  Clip
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct InvocationError: View {
    var body: some View {
        VStack(spacing: 30) {
            message
            continueButton
        }
        .padding(20)
    }
    
    private var message: some View {
        Label("Failed to load route.", systemImage: "exclamationmark.triangle.fill")
            .font(.title, weight: .heavy)
    }
    
    private var continueButton: some View {
        NavigationLink(destination: RoutesList().navigationTitle("All Routes")) {
            HStack(alignment: .center) {
                Text("Continue to All Routes")
                    .font(.largeHeadline, weight: .semibold)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption, weight: .light)
            }
            .padding(14)
            .foregroundColor(.white)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color.accent)
            .cornerRadius(10)
        }
    }
}
