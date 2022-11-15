//
//  RoutingRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 27/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RoutingRow: View {
    let routing: Routing
    let select: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    etaLabel
                    Spacer()
                    priceLabel
                }
                routingSequence
            }
            Spacer()
            goButton
        }
        .padding(.vertical, 10)
        .padding(.trailing, 15)
    }
    
    private var etaLabel: some View {
        Text(Localizable.Directions.mins(routing.travelTime))
            .font(.title3, weight: .bold)
    }
    
    private var priceLabel: some View {
        Text("$" + String(routing.price))
            .font(.largeHeadline)
            .foregroundColor(.secondary)
    }
    
    private var routingSequence: some View {
        ScrollView(.horizontal) {
            HStack {
                Image(systemName: "figure.walk")
                    .font(.callout, weight: .bold)
                next
                ForEach(routing.tracks.filter { !$0.isWalking }) { track in
                    label(for: track)
                    next
                }
                Image(systemName: "figure.walk")
                    .font(.callout, weight: .bold)
                next
                Image(systemName: "mappin.and.ellipse")
            }
        }
    }
    
    private var next: some View {
        Image(systemName: "arrowtriangle.forward.fill")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    
    @ViewBuilder private func label(for track: RoutingTrack) -> some View {
        if let company = track.company {
            HStack(spacing: 4) {
                company.category.image
                Text(track.name.isEmpty ? company.name : track.name)
            }
            .font(.callout, weight: .bold)
            .foregroundColor(company.textColor)
            .padding(5)
            .background(company.color)
            .cornerRadius(12)
        }
    }
    
    private func label(systemImage: String, text: String, color: Color, textColor: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
            Text(text)
        }
        .font(.callout, weight: .bold)
        .foregroundColor(textColor)
        .padding(5)
        .background(color)
        .cornerRadius(12)
    }
    
    private var goButton: some View {
        Button(action: select) {
            Text(Localizable.Directions.go.uppercased())
//                .font(.largeHeadline, weight: .heavy)
//                .foregroundColor(.black)
//                .padding(15)
//                .background(Color.green)
//                .cornerRadius(20)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .font(.largeHeadline, weight: .heavy)
        .foregroundColor(.black)
        
        .macCustomButton()
    }
}
