//
//  CustomFontFactory.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

enum CustomFontFactory {
    static func getFont(style: String, size: CGFloat)->Font {
        switch style.lowercased() {
        case "bold": return .custom("WixMadeforText-Bold", size: size)
        case "italic": return .custom("WixMadeforText-Italic", size: size)
        default: return .custom("WixMadeforText-Regular", size: size)
        }
    }
}
