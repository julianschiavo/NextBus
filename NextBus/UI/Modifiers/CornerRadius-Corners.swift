//
//  CornerRadius-Corners.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

#if os(iOS) || os(watchOS)
extension View {
    func cornerRadius(_ radius: CGFloat, on corners: UIRectCorner) -> some View {
        let modifier = CustomCornerRadius(radius: radius, corners: corners)
        return ModifiedContent(content: self, modifier: modifier)
    }
}

struct CustomCornerRadius: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct Shape: SwiftUI.Shape {
        var radius: CGFloat
        var corners: UIRectCorner
        
        func path(in rect: CGRect) -> Path {
            let cornerRadii = CGSize(width: radius, height: radius)
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)
            return Path(path.cgPath)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(Shape(radius: radius, corners: corners))
    }
}
#elseif os(macOS)
enum Corner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

extension View {
    func cornerRadius(_ radius: CGFloat, on corners: [Corner]) -> some View {
        cornerRadius(radius)
    }
}
#endif
