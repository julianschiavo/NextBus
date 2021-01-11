// Copyright © 2020 thislooksfun
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI
import Combine

public extension View {
    func navigationBarSearch(_ searchText: Binding<String>, toolbar: () -> UIToolbar? = { nil }) -> some View {
        overlay(
            SearchBar(text: searchText, toolbar: toolbar())
                .frame(width: 0, height: 0)
        )
    }
}

fileprivate struct SearchBar: UIViewControllerRepresentable {
    @Binding var text: String
    let toolbar: UIToolbar?
    
    func makeUIViewController(context: Context) -> SearchBarWrapperController {
        SearchBarWrapperController()
    }
    
    func updateUIViewController(_ controller: SearchBarWrapperController, context: Context) {
        controller.searchController = context.coordinator.searchController
        controller.searchController?.searchBar.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, toolbar: toolbar)
    }
    
    class Coordinator: NSObject, UISearchResultsUpdating {
        @Binding var text: String
        let toolbar: UIToolbar?
        
        let searchController: UISearchController
        
        private var subscription: AnyCancellable?
        
        init(text: Binding<String>, toolbar: UIToolbar?) {
            self._text = text
            self.toolbar = toolbar
            self.searchController = UISearchController(searchResultsController: nil)
            
            super.init()
            
            searchController.searchResultsUpdater = self
//            searchController.hidesNavigationBarDuringPresentation = true
            searchController.obscuresBackgroundDuringPresentation = false
            
            searchController.searchBar.text = self.text
            searchController.searchBar.keyboardType = .numberPad
            searchController.searchBar.inputAccessoryView = toolbar
        }
        
        deinit {
            subscription?.cancel()
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            DispatchQueue.main.async {
                self.text = text
            }
        }
    }
    
    class SearchBarWrapperController: UIViewController {
        private var didShowSearchBar = false
        
        var searchController: UISearchController? {
            didSet {
                parent?.navigationItem.searchController = searchController
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            parent?.navigationItem.searchController = searchController
        }
        
        override func viewDidAppear(_ animated: Bool) {
            parent?.navigationItem.searchController = searchController
            parent?.navigationItem.hidesSearchBarWhenScrolling = false
            guard !didShowSearchBar else { return }
            didShowSearchBar = true
            UIView.performWithoutAnimation {
                searchController?.isActive = true
                searchController?.isActive = false
            }
        }
    }
}
