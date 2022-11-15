//
//  DaysPicker.swift
//  NextBus
//
//  Created by Julian Schiavo on 3/10/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct DaysPicker: View {
    @Binding var days: [String]
    
    private func isSelected(index: Int) -> Bool {
        let name = Calendar.current.standaloneWeekdaySymbols[index]
        return days.contains(name)
    }
    
    var body: some View {
        VStack {
            title
            picker
        }
        .padding(.vertical, 8)
    }
    
    private var title: some View {
        HStack {
            Text(Localizable.repeats)
            Spacer()
            repeatsLabel
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
    }
    
    private var repeatsLabel: some View {
        if days.count == Calendar.current.standaloneWeekdaySymbols.count {
            return Text(Localizable.everyday)
        } else if days.count > 4 {
            return Text(Localizable.someDays)
        }
        
        var dayNames = days
        if days.count > 2 {
            dayNames = days.map {
                let index = Calendar.current.standaloneWeekdaySymbols.firstIndex(of: $0)
                guard let index = index else { return $0 }
                return Calendar.current.shortStandaloneWeekdaySymbols[index]
            }
        }
        
        let formatter = ListFormatter()
        let text = formatter.string(from: dayNames) ?? Localizable.someDays
        return Text(text)
    }
    
    private var picker: some View {
        HStack {
            ForEach(Array(Calendar.current.standaloneWeekdaySymbols.indices), id: \.self) { index in
                option(at: index)
            }
        }
    }
    
    private func option(at index: Int) -> some View {
        let isSelected = isSelected(index: index)
        let symbol = Calendar.current.veryShortStandaloneWeekdaySymbols[index]
        return Button {
            select(at: index)
        } label: {
            Text(symbol)
                .foregroundColor(isSelected ? .primary : .secondary)
                .padding(10)
                .background(isSelected ? Color.accent : Color.secondaryBackground)
                .clipShape(Circle())
        }
    }
    
    private func select(at index: Int) {
        let name = Calendar.current.standaloneWeekdaySymbols[index]
        
        if days.contains(name) {
            days.removeAll { $0 == name }
        } else {
            days.append(name)
        }
        
        days.sort {
            let firstIndex = Calendar.current.standaloneWeekdaySymbols.firstIndex(of: $0) ?? 0
            let secondIndex = Calendar.current.standaloneWeekdaySymbols.firstIndex(of: $1) ?? 0
            return firstIndex < secondIndex
        }
    }
}
