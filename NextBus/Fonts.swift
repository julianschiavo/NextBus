//
//  Font-Custom.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

extension Font {
    enum Style {
        case hugeTitle
        case largerTitle
        case largeTitle
        case title
        case title2 // custom
        case title3 // title 2
        case largeHeadline // title 3
        case headline
        case subheadline
        case body
        case callout
        case footnote
        case caption
        case caption2
        
        var swiftUITextStyle: TextStyle? {
            switch self {
            // larger title, huge title are custom
            case .largeTitle: return .largeTitle
            case .title: return .title
                // title 2 is custom
            case .title3: return .title2
            case .largeHeadline: return .title3
            case .headline: return .headline
            case .subheadline: return .subheadline
            case .body: return .body
            case .callout: return .callout
            case .footnote: return .footnote
            case .caption: return .caption
            case .caption2: return .caption2
            default: return nil
            }
        }
        
        var size: CGFloat {
            switch self {
            case .hugeTitle: return 50
            case .largerTitle: return 40
            case .title2: return 25
            default: return 100
            }
        }
        
        var font: Font {
            if let swiftUITextStyle = swiftUITextStyle {
                return Font.system(swiftUITextStyle)
            } else {
                return Font.system(size: size)
            }
        }
    }
    
    static func custom(_ style: Style, weight: Weight = .regular) -> Font {
        style.font.weight(weight)
    }
}

extension View {
    /// Sets the font to use when displaying this text.
    ///
    /// - Parameter font: The font to use when displaying this text.
    /// - Returns: Text that uses the font you specify.
    func font(_ style: Font.Style, weight: Font.Weight = .regular, withMonospacedDigits: Bool = false) -> some View {
        var font = Font.custom(style, weight: weight)
        if withMonospacedDigits { font = font.monospacedDigit() }
        return self.font(font)
    }
}

extension Text {
    /// Sets the font to use when displaying this text.
    ///
    /// - Parameter font: The font to use when displaying this text.
    /// - Returns: Text that uses the font you specify.
    func font(_ style: Font.Style, weight: Font.Weight = .regular, withMonospacedDigits: Bool = false) -> Text {
        var font = Font.custom(style, weight: weight)
        if withMonospacedDigits { font = font.monospacedDigit() }
        return self.font(font)
    }
}
