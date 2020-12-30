//
//  SearchView.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 7/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText = ""
    
    var body: some View {
        let isButtonDisabled = searchText.isEmpty
        let buttonColor = searchText.isEmpty ? .gray : Color.primary
        
        return ScrollView {
            VStack {
                Text(Localizations.searchText).title()
                Spacer(minLength: 20)
                
                TextField(Localizations.searchBarText, text: $searchText)
                    .textContentType(.postalCode)
                
                NavigationLink(destination: SearchResultsView(searchText: self.searchText)) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text(Localizations.searchHeader)
                    }
                }
                .disabled(isButtonDisabled)
                .foregroundColor(buttonColor)
            }
        }
        .navigationBarTitle(Localizations.searchHeader)
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView(searchText: "13")
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 3 - 38mm"))
            SearchView(searchText: "")
        }
    }
}
#endif
