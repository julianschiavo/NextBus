//
//  AddToSiriButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import IntentsUI
import SwiftUI

struct AddToSiriButton: UIViewControllerRepresentable {
    let shortcut: INShortcut
    let completion: () -> Void
    
    func makeUIViewController(context: Context) -> AddToSiriViewController {
        AddToSiriViewController(shortcut: shortcut, completion: completion)
    }
    
    func updateUIViewController(_ uiViewController: AddToSiriViewController, context: Context) {
    }
}

class AddToSiriViewController: UIViewController, INUIAddVoiceShortcutButtonDelegate, INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
    let shortcut: INShortcut
    let completion: () -> Void
    
    init(shortcut: INShortcut, completion: @escaping () -> Void) {
        self.shortcut = shortcut
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = INUIAddVoiceShortcutButton(style: .black)
        button.cornerRadius = 0
        button.delegate = self
        button.shortcut = shortcut
        
        self.view.addSubview(button)
        view.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - INUIAddVoiceShortcutButtonDelegate
    
    func present(_ controller: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        controller.delegate = self
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true)
    }
    
    func present(_ controller: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        controller.delegate = self
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true)
    }
    
    // MARK: - INUIAddVoiceShortcutViewControllerDelegate
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true)
        completion()
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true)
    }
    
    // MARK: - INUIEditVoiceShortcutViewControllerDelegate
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true)
        completion()
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true)
    }
}
