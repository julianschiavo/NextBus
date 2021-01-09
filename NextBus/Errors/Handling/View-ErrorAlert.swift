//
//  View-ErrorAlert.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

extension View {
    /// Presents an alert to the user if an error occurs.
    /// - Parameters:
    ///   - errorBinding: A binding to an Optional Error. When the binding
    ///     represents a non-`nil` item, an alert will be shown.
    func alert<E: AnyIdentifiableError>(errorBinding: Binding<E?>) -> some View {
        overlay(
            EmptyView()
                .alert(item: errorBinding) { error in
                    self.alert(for: error)
                }
        )
    }
    
    /// Presents an alert to the user if an error occurs.
    /// - Parameters:
    ///   - errorBinding: A binding to an Optional Error. When the binding
    ///     represents a non-`nil` item, an alert will be shown.
    func alert(errorBinding: Binding<IdentifiableError?>) -> some View {
        overlay(
            EmptyView()
                .alert(item: errorBinding) { error in
                    self.alert(for: error.error)
                }
        )
    }
    
    /// Creates an alert for an error
    /// - Parameter error: The error
    /// - Returns: The alert
    private func alert(for error: Error) -> Alert {
        print("ERROR", error)
        
        let title = Text(error.userVisibleTitle)
        let message = Text(error.userVisibleOverallDescription)
        let button = Alert.Button.default(Text("OK"))
        return Alert(title: title, message: message, dismissButton: button)
    }
}
