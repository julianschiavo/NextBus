//
//  CustomAddToSiriButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import IntentsUI
import SwiftUI

struct CustomAddToSiriButton: View {
    @Binding var sheet: Sheet?
    let route: Route?
    let stop: Stop?
    
    var body: some View {
        Button {
            sheet = .addToSiri(route: route, stop: stop)
        } label: {
            Label(Localizable.addToSiri, systemImage: "mic.fill")
                .alignedHorizontally(to: .leading)
                .iOSPadding(.vertical, 10)
                .iOSPadding(.horizontal, 12)
                .iOSBackground(Color.quaternaryBackground)
        }
        .macCustomButton()
    }
}

struct AddVoiceShortcutViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    let route: Route?
    let stop: Stop?
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIViewController(context: Context) -> INUIAddVoiceShortcutViewController {
        let intent = GetUpcomingBusesIntent()
        intent.source = .custom
        intent.route = route?.intent
        intent.stop = stop?.intent
        
        let shortcut: INShortcut
        if let route = route {
            if let stop = stop {
                shortcut = .getUpcomingBuses(route: route, stop: stop)
            } else {
                shortcut = .getUpcomingBuses(route: route)
            }
        } else {
            shortcut = .getUpcomingBuses()
        }
        
        let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: INUIAddVoiceShortcutViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
        // MARK: - INUIAddVoiceShortcutViewControllerDelegate
        
        func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
            controller.dismiss(animated: true)
        }
        
        func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
            controller.dismiss(animated: true)
        }
        
        // MARK: - INUIEditVoiceShortcutViewControllerDelegate
        
        func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
            controller.dismiss(animated: true)
        }
        
        func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
            controller.dismiss(animated: true)
        }
        
        func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
            controller.dismiss(animated: true)
        }
    }
}
