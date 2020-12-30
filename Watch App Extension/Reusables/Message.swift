//
//  Message.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Message: View {
    
    let image: Image?
    let titleText: String
    let subtitleText: String
    let onAppear: (() -> Void)?
    
    init(image: Image? = nil, title: String, subtitle: String, onAppear: (() -> Void)? = nil) {
        self.image = image
        self.titleText = title
        self.subtitleText = subtitle
        self.onAppear = onAppear
    }
    
    init(imageName: String, title: String, subtitle: String, onAppear: (() -> Void)? = nil) {
        let image = Image(systemName: imageName)
        self.init(image: image, title: title, subtitle: subtitle, onAppear: onAppear)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Spacer(minLength: 25)
                HStack {
                    VStack(alignment: .leading) {
                        image
                            .imageScale(.large)
                            .font(.headline)
                        Text(titleText)
                            .title()
                        Text(subtitleText)
                            .subtitle()
                    }
                    Spacer()
                }
                Spacer(minLength: 25)
            }
        }
        .lineLimit(nil)
        .onAppear(perform: onAppear)
    }
}

#if DEBUG
struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Message(imageName: "doc", title: "Title", subtitle: "Subtitle")
            Message(title: "Title", subtitle: "Subtitle that goes over multiple lines")
            Message(imageName: "doc", title: "Title", subtitle: "Subtitle that goes over too many lines to fit on the screen because we need to test for every possibility as some people may have large text sizes")
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 3 - 38mm"))
        }
    }
}
#endif
