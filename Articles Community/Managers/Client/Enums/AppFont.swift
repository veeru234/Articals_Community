//
//  AppFont.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import SwiftUI
import UIKit

enum AppFont {
    enum Weight: String {
        case thin = "Roboto-Thin"
        case light = "Roboto-Light"
        case regular = "Roboto-Regular"
        case medium = "Roboto-Medium"
        case bold = "Roboto-Bold"
        case black = "Roboto-Black"
    }

    // SwiftUI
    static func font(_ weight: Weight, size: CGFloat, style: Font.TextStyle = .body) -> Font {
        .custom(weight.rawValue, size: size, relativeTo: style)
    }

    // UIKit
    static func uiFont(_ weight: Weight, size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
        let base = UIFont(name: weight.rawValue, size: size) ?? .systemFont(ofSize: size)
        return UIFontMetrics(forTextStyle: style).scaledFont(for: base)
    }
}