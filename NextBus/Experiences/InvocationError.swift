//
//  InvocationError.swift
//  Clip
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct InvocationError: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 30) {
            message
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                continueButton
            }
        }
        .padding(20)
    }
    
    private var message: some View {
        Label(Localizable.Clip.failedToLoadRoute, systemImage: "exclamationmark.triangle.fill")
            .font(.title, weight: .heavy)
    }
    
    private var continueButton: some View {
        HStack(alignment: .center) {
            Text(Localizable.Clip.continueToRoutes)
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
