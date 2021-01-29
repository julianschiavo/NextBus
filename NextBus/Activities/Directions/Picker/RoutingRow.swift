//
//  RoutingRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 27/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RoutingRow: View {
    let directions: Directions
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
        Text(String(directions.travelTime) + " mins")
            .font(.title3, weight: .bold)
    }
    
    private var priceLabel: some View {
        Text("$" + String(directions.price))
            .font(.largeHeadline)
            .foregroundColor(.secondary)
    }
    
    private var routingSequence: some View {
        ScrollView(.horizontal) {
            HStack {
                Image(systemName: "figure.walk")
                    .font(.callout, weight: .bold)
                next
                ForEach(directions.tracks) { track in
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
        if let company = Company(rawValue: track.company) {
            label(systemImage: company.category.iconName, text: track.name.isEmpty ? company.name : track.name, color: company.color, textColor: company.textColor)
        } else if track.company == "MTR" {
            label(systemImage: "tram.tunnel.fill", text: track.name, color: Color(red: 152 / 255, green: 45 / 255, blue: 69 / 255, opacity: 1), textColor: .white)
        } else if track.company == "TRAM" {
            label(systemImage: "tram.fill", text: track.name, color: Color(red: 6 / 255, green: 105 / 255, blue: 65 / 255, opacity: 1), textColor: .white)
        } else if track.company == "FERRY" {
            label(systemImage: "drop.fill", text: track.name, color: Color(red: 13 / 255, green: 68 / 255, blue: 148 / 255, opacity: 1), textColor: .white)
        } else {
            label(systemImage: "questionmark", text: "", color: .secondary, textColor: .primary)
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
            Text("GO")
                .font(.largeHeadline, weight: .heavy)
                .foregroundColor(.black)
                .padding(15)
                .background(Color.green)
                .cornerRadius(20)
        }
        .macCustomButton()
    }
}
