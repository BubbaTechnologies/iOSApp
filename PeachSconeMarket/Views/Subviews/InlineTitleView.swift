//
//  InlineTitleView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct InlineTitleView: View {
    var body: some View {
        Text("Peach Scone Market")
            .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.09, relativeTo: .title2))
            .minimumScaleFactor(0.25)
            .lineLimit(1)
            .foregroundColor(Color("DarkText"))
            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.width * 0.15)
    }
}

struct InlineTitleView_Previews: PreviewProvider {
    static var previews: some View {
        InlineTitleView()
    }
}
