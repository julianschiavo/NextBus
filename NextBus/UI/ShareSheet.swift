//
//  ShareSheet.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

#if os(iOS)
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let activities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: activities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
#elseif os(macOS)
struct ShareSheet: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let items: [Any]
    let activities: [Any]?
    
    var body: some View {
        VStack {
            _ShareSheet(items: items, activities: activities)
            Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .frame(minWidth: 200, minHeight: 200)
    }
}

struct _ShareSheet: NSViewRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    let items: [Any]
    let activities: [Any]?
    
    func makeNSView(context: Context) -> NSView {
        NSView()
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        guard presentationMode.wrappedValue.isPresented else { return }
        let picker = NSSharingServicePicker(items: items)
        DispatchQueue.main.async {
            picker.show(relativeTo: .zero, of: nsView, preferredEdge: .minY)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSSharingServicePickerDelegate {
        let parent: _ShareSheet
        
        init(_ parent: _ShareSheet) {
            self.parent = parent
        }
        
        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
#else
struct ShareSheet: View {
    let items: [Any]
    let activities: [Any]?
    
    var body: some View {
        EmptyView()
    }
}
#endif
