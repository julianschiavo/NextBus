//
//  ShareSheet.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
    let items: [Any]
    let activities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: activities)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
//            DispatchQueue.main.async {
//                self.isPresented = false
//            }
        }
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
