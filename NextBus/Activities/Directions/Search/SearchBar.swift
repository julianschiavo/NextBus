//
//  SearchBar.swift
//  NextBus
//
//  Created by Julian Schiavo on 24/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

#if os(iOS)
import UIKit

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    @Binding var isFocused: Bool
    var onEnter: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isFocused: $isFocused, onEnter: onEnter)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: Context) {
        searchBar.text = text
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool
        var onEnter: () -> Void
        
        init(text: Binding<String>, isFocused: Binding<Bool>, onEnter: @escaping () -> Void) {
            _text = text
            _isFocused = isFocused
            self.onEnter = onEnter
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            withAnimation {
                isFocused = true
            }
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            withAnimation {
                isFocused = false
            }
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onEnter()
        }
    }
}
#elseif os(macOS)
//import AppKit

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    @Binding var isFocused: Bool
    var onEnter: () -> Void
    
    var body: some View {
        TextField(Localizable.Directions.searchForLocation, text: $text) { isFocused in
            self.isFocused = isFocused
        } onCommit: {
            onEnter()
        }
        .padding(5)
        .cornerRadius(10)
        .textFieldStyle(.plain)
    }
}

//struct SearchBar: NSViewRepresentable {
//    @Binding var text: String
//    let placeholder: String
//    @Binding var isFocused: Bool
//    var onEnter: () -> Void
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(text: $text, isFocused: $isFocused, onEnter: onEnter)
//    }
//
//    func makeNSView(context: Context) -> NSSearchField {
//        let field = NSSearchField(string: placeholder)
//        field.delegate = context.coordinator
//
//
////        let searchBar = UISearchBar(frame: .zero)
////        searchBar.delegate = context.coordinator
////        searchBar.placeholder = placeholder
////        searchBar.searchBarStyle = .minimal
//        return field
//    }
//
//    func updateNSView(_ searchField: NSSearchField, context: Context) {
//        searchField.stringValue = text
//    }
//
//    class Coordinator: NSObject, NSSearchFieldDelegate {
//        @Binding var text: String
//        @Binding var isFocused: Bool
//        var onEnter: () -> Void
//
//        init(text: Binding<String>, isFocused: Binding<Bool>, onEnter: @escaping () -> Void) {
//            _text = text
//            _isFocused = isFocused
//            self.onEnter = onEnter
//        }
//
//        func controlTextDidChange(_ obj: Notification) {
//            guard let searchField = obj.object as? NSSearchField else { return }
//            text = searchField.stringValue
//        }
//
//        func controlTextDidBeginEditing(_ obj: Notification) {
//            withAnimation {
//                isFocused = true
//            }
//        }
//
//        func controlTextDidEndEditing(_ obj: Notification) {
//            withAnimation {
//                isFocused = false
//            }
//        }
//
////        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
////            search()
////        }
//    }
//}
#endif
