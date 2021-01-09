//
//  ColorOverride.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation
import SwiftUI

private extension Method {
    func exchange(with newMethod: Method) {
        method_exchangeImplementations(self, newMethod)
    }
}

//#if os(iOS)
extension UIColor {
    static private func getMethod(_ selector: Selector) -> Method? {
        class_getClassMethod(UIColor.self, selector)
    }
    
    static let classInit: Void = {
        guard let backgroundMethod = getMethod(#selector(getter: systemBackground)),
              let groupedBackgroundMethod = getMethod(#selector(getter: systemGroupedBackground)),
              let appBackgroundMethod = getMethod(#selector(getter: appBackground)) else { return }
        backgroundMethod.exchange(with: appBackgroundMethod)
        groupedBackgroundMethod.exchange(with: appBackgroundMethod)
        
        guard let secondaryBackgroundMethod = getMethod(#selector(getter: secondarySystemBackground)),
              let secondaryGroupedBackgroundMethod = getMethod(#selector(getter: secondarySystemGroupedBackground)),
              let appSecondaryBackgroundMethod = getMethod(#selector(getter: secondaryAppBackground)) else { return }
        secondaryBackgroundMethod.exchange(with: appSecondaryBackgroundMethod)
        secondaryGroupedBackgroundMethod.exchange(with: appSecondaryBackgroundMethod)
        
        guard let tertiaryBackgroundMethod = getMethod(#selector(getter: tertiarySystemBackground)),
              let tertiaryGroupedBackgroundMethod = getMethod(#selector(getter: tertiarySystemGroupedBackground)),
              let appTertiaryBackgroundMethod = getMethod(#selector(getter: tertiaryAppBackground)) else { return }
        tertiaryBackgroundMethod.exchange(with: appTertiaryBackgroundMethod)
        tertiaryGroupedBackgroundMethod.exchange(with: appTertiaryBackgroundMethod)
    }()
    
    static let accent = UIColor(red: 222/255, green: 41/255, blue: 16/255, alpha: 1)
    
    @objc static let appBackground = UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
        default:
            return UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        }
    }
    @objc static let secondaryAppBackground = UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return UIColor(red: 242 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        default:
            return UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        }
    }
    @objc static let tertiaryAppBackground = UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return UIColor(red: 229 / 255, green: 239 / 255, blue: 239 / 255, alpha: 1)
        default:
            return UIColor(red: 44 / 255, green: 44 / 255, blue: 46 / 255, alpha: 1)
        }
    }
    @objc static let quaternaryAppBackground = UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return UIColor(red: 216 / 255, green: 231 / 255, blue: 231 / 255, alpha: 1)
        default:
            return UIColor(red: 58 / 255, green: 58 / 255, blue: 59 / 255, alpha: 1)
        }
    }
}
//#elseif os(macOS)
//extension NSColor {
//    @objc static let appBackground = NSColor(name: nil) { appearance -> NSColor in
//        switch appearance.name {
//        case .aqua, .vibrantLight, .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight:
//            return NSColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
//        default:
//            return NSColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
//        }
//    }
//    @objc static let secondaryAppBackground = NSColor(name: nil) { appearance -> NSColor in
//        switch appearance.name {
//        case .aqua, .vibrantLight, .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight:
//            return NSColor(red: 242 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
//        default:
//            return NSColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
//        }
//    }
//    @objc static let tertiaryAppBackground = NSColor(name: nil) { appearance -> NSColor in
//        switch appearance.name {
//        case .aqua, .vibrantLight, .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight:
//            return NSColor(red: 229 / 255, green: 239 / 255, blue: 239 / 255, alpha: 1)
//        default:
//            return NSColor(red: 44 / 255, green: 44 / 255, blue: 46 / 255, alpha: 1)
//        }
//    }
//    @objc static let quaternaryAppBackground = NSColor(name: nil) { appearance -> NSColor in
//        switch appearance.name {
//        case .aqua, .vibrantLight, .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight:
//            return NSColor(red: 216 / 255, green: 231 / 255, blue: 231 / 255, alpha: 1)
//        default:
//            return NSColor(red: 58 / 255, green: 58 / 255, blue: 59 / 255, alpha: 1)
//        }
//    }
//}
//#endif

extension Color {
    static let accent = Color(red: 222/255, green: 41/255, blue: 16/255)
    
    static var background: Color { Color(.appBackground) }
    static var secondaryBackground: Color { Color(.secondaryAppBackground) }
    static var tertiaryBackground: Color { Color(.tertiaryAppBackground) }
    static var quaternaryBackground: Color { Color(.quaternaryAppBackground) }
}
