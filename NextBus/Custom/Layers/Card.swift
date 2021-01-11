//
//  Card.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Card<Content: View>: View {
    
    private let title: String
    private let systemImage: String
    private let bordered: Bool
    
    private let content: Content
    
    init(_ title: String? = nil, systemImage: String? = nil, withBorder bordered: Bool = true, @ViewBuilder _ content: () -> Content) {
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
//        .padding(15)
//        .background(Color.secondaryBackground)
//        .cornerRadius(14)
    }
    
    private var borderedContent: some View {
        content
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(UIColor.opaqueSeparator), lineWidth: 1)
            )
            .cornerRadius(10)
    }
    
    private var header: some View {
        Label(title, systemImage: systemImage)
            .font(.largeHeadline, weight: .bold)
            .padding(.horizontal, 5)
            .alignedHorizontally(to: .leading)
    }
}
