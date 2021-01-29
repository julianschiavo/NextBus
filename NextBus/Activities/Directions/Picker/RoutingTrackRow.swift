//
//  RoutingTrackRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RoutingTrackRow: View {
    let track: RoutingTrack
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            name
            info
        }
        .padding(.vertical, 10)
    }
    
    @ViewBuilder private var name: some View {
        if let company = Company(rawValue: track.company) {
            name(systemImage: company.category.iconName, text: track.name.isEmpty ? company.name : track.name, color: company.color, textColor: company.textColor)
        } else if track.company == "MTR" {
            name(systemImage: "tram.tunnel.fill", text: track.name, color: Color(red: 152 / 255, green: 45 / 255, blue: 69 / 255, opacity: 1), textColor: .white)
        } else if track.company == "TRAM" {
            name(systemImage: "tram.fill", text: track.name, color: Color(red: 6 / 255, green: 105 / 255, blue: 65 / 255, opacity: 1), textColor: .white)
        } else if track.company == "FERRY" {
            name(systemImage: "drop.fill", text: track.name, color: Color(red: 13 / 255, green: 68 / 255, blue: 148 / 255, opacity: 1), textColor: .white)
        } else {
            name(systemImage: "questionmark", text: "", color: .secondary, textColor: .primary)
        }
    }
    
    private func name(systemImage: String, text: String, color: Color, textColor: Color) -> some View {
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
    
    @ViewBuilder private var info: some View {
        if Company(rawValue: track.company) != nil {
            infoLabel(title: "Take the \(track.name) Bus")
        } else if track.company == "TRAM" {
            infoLabel(title: "Take the \(track.name) Tram")
        } else if track.company == "FERRY" {
            infoLabel(title: "Take the \(track.name) Ferry")
        } else if track.company == "MTR" {
            infoLabel(title: "Ride on the \(track.name)")
        } else {
            infoLabel(title: "Failed to load instructions")
        }
    }
    
    private func infoLabel(title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline, weight: .bold)
            Text("from " + track.originName)
                .font(.callout)
                .foregroundColor(.secondary)
            Text("to " + track.destinationName)
                .font(.callout, weight: .semibold)
                .foregroundColor(.secondary)
        }
    }
}
