//
//  ToggleView.swift
//  Carou
//
//  Created by Matt Groholski on 1/22/24.
//

import SwiftUI

struct ToggleView: View {
    var text: String
    @Binding var toggleValue: Bool
    
    var body: some View {
        GeometryReader { reader in
            Rectangle()
                .fill(.clear)
                .border(.clear)
                .cornerRadius(2.5)
                .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
                .overlay{
                    Toggle(isOn: $toggleValue) {
                        Text(text)
                            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.065, relativeTo: .body))
                    }
                    .padding(.horizontal, reader.size.width * 0.05)
                }
        }
    }
}

#Preview {
    ToggleView(text: "Private Account", toggleValue: .constant(true))
}
