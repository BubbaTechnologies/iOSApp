//
//  Title.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        Text("Peach Scone Market")
            .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.13))
            .minimumScaleFactor(0.25)
            .lineLimit(2)
            .foregroundColor(Color("DarkText"))
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
