//
//  ListSectionHeader.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ListSectionHeader: View {
    
    let image: Image
    let text: Text
    
    init(imageName: String, text: String) {
        self.image = Image(systemName: imageName)
        self.text = Text(text)
    }
    
    var body: some View {
        HStack {
            image
            text
        }
    }
    
}
