//
//  InlineTitleView.swift
//  Carou
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct InlineTitleView: View {
    var body: some View {
        GeometryReader{ reader in
            Text("Clothing Carou")
                .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.09, relativeTo: .title2))
                .minimumScaleFactor(0.25)
                .lineLimit(1)
                .foregroundColor(Color("DarkFontColor"))
                .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}

struct InlineTitleView_Previews: PreviewProvider {
    static var previews: some View {
        InlineTitleView()
    }
}
