//
//  Title.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        GeometryReader{ reader in
            Text("Peach Scone Market")
                .font(CustomFontFactory.getFont(style: "Bold", size: 60, relativeTo: .title))
                .foregroundColor(Color("DarkText"))
                .padding(.horizontal, reader.size.width * 0.08)
                .lineLimit(2)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color("DarkText"))
                .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
