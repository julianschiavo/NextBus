//
//  Label-AlignedText.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

extension HorizontalAlignment {
    struct LabelText: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.leading]
        }
    }
    
    static let labelText = HorizontalAlignment(LabelText.self)
}

struct AlignedTextLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .top) {
            configuration.icon
                .alignmentGuide(.labelText) { d in d[.trailing] }
            configuration.title
        }
    }
}
