//
//  CustomFontFactory.swift
//  Carou
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

enum CustomFontFactory {
    static func getFont(style: String, size: CGFloat, relativeTo: Font.TextStyle)->Font {
        switch style.lowercased() {
        case "bold": return .custom("WixMadeforText-Bold", size: size, relativeTo: relativeTo)
        case "italic": return .custom("WixMadeforText-Italic", size: size, relativeTo: relativeTo)
        default: return .custom("WixMadeforText-Regular", size: size , relativeTo: relativeTo)
        }
    }
}
