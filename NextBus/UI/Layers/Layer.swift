//
//  Layer.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Layer<Content: View>: View {
    
    typealias Depth = LayerDepth
    
    private let depth: Depth
    
    private let title: String
    private let systemImage: String
    private let bordered: Bool
    
    private let content: Content
    
    init(_ depth: Depth, title: String? = nil, systemImage: String? = nil, withBorder bordered: Bool = true, @ViewBuilder _ content: () -> Content) {
        self.depth = depth
        self.title = title ?? ""
        self.systemImage = systemImage ?? ""
        self.bordered = bordered
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if !title.isEmpty {
                header
            }
            if bordered {
                borderedContent
            } else {
                content
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(depth.backgroundColor)
        .cornerRadius(14, on: [.topLeft, .topRight])
        .iOSBackground(depth.lowerBackgroundColor)
    }
    
    private var borderedContent: some View {
        content
            .roundedBorder(10)
            .frame(maxWidth: .infinity)
    }
    
    private var header: some View {
        Label(title, systemImage: systemImage)
            .font(.largeHeadline, weight: .bold)
            .padding(.horizontal, 5)
            .alignedHorizontally(to: .leading)
    }
}
