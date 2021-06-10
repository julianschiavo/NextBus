//
//  ArrivalTimeView.swift
//  WidgetExtension
//
//  Created by Julian Schiavo on 13/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Intents
import SwiftUI
import WidgetKit

struct ArrivalTimeView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    
    let entry: ArrivalTimeProvider.Entry
    
    var body: some View {
        switch entry.data {
        case let .arrivals(arrivals):
            contents(with: arrivals)
        case .errorNoRoutesSelected:
            NoRoutesError()
        case .errorFailedToLoad:
            FailedToLoadError()
        case .errorUpgradeRequired:
            UpgradeRequiredError()
        }
    }
    
    @ViewBuilder private func contents(with arrivals: [ArrivalTimeEntry.RouteArrival]) -> some View {
        switch widgetFamily {
        case .systemSmall:
            Small(source: entry.configuration.source, widgetStyle: entry.configuration.widgetStyle, arrivals: arrivals)
        case .systemMedium, .systemLarge:
            MediumLarge(source: entry.configuration.source, widgetStyle: entry.configuration.widgetStyle,arrivals: arrivals)
        @unknown default:
            fatalError("Unknown Widget Family")
        }
    }
}

fileprivate struct Small: View {
    let source: INSource
    let widgetStyle: INWidgetStyle
    let arrivals: [ArrivalTimeEntry.RouteArrival]
    
    var body: some View {
        if let arrival = arrivals.first {
            body(for: arrival)
        } else {
            NoRoutesError()
        }
    }
    
    private func foregroundColor(for arrival: ArrivalTimeEntry.RouteArrival) -> Color {
        switch widgetStyle {
        case .color: return arrival.route.company.textColor
        default: return .primary
        }
    }
    
    @ViewBuilder private func background(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        switch widgetStyle {
        case .color:
            LinearGradient(gradient: Gradient(colors: [arrival.route.company.color, arrival.route.company.color.opacity(0.75)]), startPoint: .top, endPoint: .bottom)
        case .gray:
            LinearGradient(gradient: Gradient(colors: [.tertiaryBackground, .secondaryBackground]), startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            Color.background
        }
    }
    
    @ViewBuilder private func body(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                HStack(alignment: .top) {
                    routeLabel(for: arrival)
                    Spacer()
                    sourceIcon
                }
                destinationLabel(for: arrival)
                Spacer()
                timeLabel(for: arrival)
                secondaryTimeLabel(for: arrival)
            }
            Spacer()
        }
        .foregroundColor(foregroundColor(for: arrival))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background(background(for: arrival))
        .widgetURL(shareURL(for: arrival))
    }
    
    private func shareURL(for arrival: ArrivalTimeEntry.RouteArrival) -> URL? {
        StatusExperience(company: arrival.route.company, routeID: arrival.route.id, stopID: arrival.stop.id).toURL()
    }
    
    private func routeLabel(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        Text(arrival.route.localizedName)
            .font(.title2, weight: .heavy, withMonospacedDigits: true)
            .foregroundColor(widgetStyle != .color ? arrival.route.company.textColor : foregroundColor(for: arrival))
            .padding(widgetStyle != .color ? 6 : 0)
            .background(widgetStyle != .color ? arrival.route.company.color : Color.clear)
            .cornerRadius(10)
    }
    
    @ViewBuilder private var sourceIcon: some View {
        switch source {
        case .favorites:
            Image(systemName: "heart.fill")
                .font(.callout)
                .foregroundColor(.secondary)
        case .recents:
            Image(systemName: "clock.arrow.circlepath")
                .font(.callout)
                .foregroundColor(.secondary)
        default:
            EmptyView()
        }
    }
    
    private func destinationLabel(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        Text("to " + arrival.route.localizedDestination)
            .font(.caption)
            .foregroundColor(foregroundColor(for: arrival).opacity(0.8))
    }
    
    @ViewBuilder private func timeLabel(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        if let date = arrival.etas.first?.date {
            Text(date, style: .time)
                .font(.largeHeadline, weight: .bold, withMonospacedDigits: true)
        } else {
            Text(Localizable.Widgets.ArrivalTime.notAvailable)
                .font(.subheadline, weight: .semibold)
        }
    }
    
    @ViewBuilder private func secondaryTimeLabel(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        if let date = arrival.etas[safe: 1]?.date {
            Text(date, style: .time)
                .font(.footnote, withMonospacedDigits: true)
                .foregroundColor(foregroundColor(for: arrival).opacity(0.8))
        }
    }
}

fileprivate struct MediumLarge: View {
    @Environment(\.widgetFamily) private var widgetFamily
    
    let source: INSource
    let widgetStyle: INWidgetStyle
    let arrivals: [ArrivalTimeEntry.RouteArrival]
    
    private var count: Int {
        widgetFamily == .systemMedium ? 2 : 4
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(arrivals.prefix(count)) { arrival in
                body(for: arrival)
                Divider()
            }
        }
    }
    
    private func foregroundColor(for arrival: ArrivalTimeEntry.RouteArrival) -> Color {
        switch widgetStyle {
        case .color: return arrival.route.company.textColor
        default: return .primary
        }
    }
    
    @ViewBuilder private func background(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        switch widgetStyle {
        case .color:
            LinearGradient(gradient: Gradient(colors: [arrival.route.company.color, arrival.route.company.color.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case .gray:
            LinearGradient(gradient: Gradient(colors: [.tertiaryBackground, .secondaryBackground]), startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            Color.background
        }
    }
    
    @ViewBuilder private func body(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        Link(destination: shareURL(for: arrival)!) {
            HStack(alignment: .center, spacing: 10) {
                routeLabel(for: arrival)
                infoLabel(for: arrival)
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    timeLabel(for: arrival)
                    secondaryTimeLabel(for: arrival)
                }
            }
        }
        .foregroundColor(foregroundColor(for: arrival))
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(background(for: arrival))
    }
    
    private func shareURL(for arrival: ArrivalTimeEntry.RouteArrival) -> URL? {
        StatusExperience(company: arrival.route.company, routeID: arrival.route.id, stopID: arrival.stop.id).toURL()
    }
    
    private func routeLabel(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        Text(arrival.route.localizedName)
            .font(.title3, weight: .heavy, withMonospacedDigits: true)
            .foregroundColor(widgetStyle != .color ? arrival.route.company.textColor : foregroundColor(for: arrival))
            .padding(widgetStyle != .color ? 6 : 0)
            .background(widgetStyle != .color ? arrival.route.company.color : Color.clear)
            .cornerRadius(10)
    }
    
    private func infoLabel(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        (Text(arrival.stop.localizedName) + (Text(" to ") + Text(arrival.route.localizedDestination)).fontWeight(.bold))
            .font(.caption)
            .foregroundColor(foregroundColor(for: arrival).opacity(0.8))
    }
    
    @ViewBuilder private func timeLabel(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        if let date = arrival.etas.first?.date {
            Text(date, style: .time)
                .font(.largeHeadline, weight: .bold, withMonospacedDigits: true)
        } else {
            Text("No arrival time")
                .font(.footnote, weight: .medium)
        }
    }
    
    @ViewBuilder private func secondaryTimeLabel(for arrival: ArrivalTimeEntry.RouteArrival) -> some View {
        if let date = arrival.etas[safe: 1]?.date {
            Text(date, style: .time)
                .font(.callout, withMonospacedDigits: true)
                .foregroundColor(foregroundColor(for: arrival).opacity(0.8))
        }
    }
}

fileprivate struct NoRoutesError: View {
    var body: some View {
        VStack(spacing: 8) {
            Text(Localizable.Widgets.ArrivalTime.noRoutesSelected)
                .font(.headline)
            Text(Localizable.Widgets.ArrivalTime.noRoutesSelectedDescription)
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding(16)
    }
}

fileprivate struct FailedToLoadError: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2, weight: .heavy)
                .foregroundColor(.red)
            Text(Localizable.Widgets.ArrivalTime.failedToLoad)
                .font(.headline)
        }
        .multilineTextAlignment(.center)
        .padding(16)
    }
}

fileprivate struct UpgradeRequiredError: View {
    var body: some View {
        VStack(spacing: 8) {
            Text(Localizable.Widgets.ArrivalTime.upgradeRequired)
                .font(.headline)
            Text(Localizable.Widgets.ArrivalTime.upgradeRequiredDescription)
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding(16)
    }
}
