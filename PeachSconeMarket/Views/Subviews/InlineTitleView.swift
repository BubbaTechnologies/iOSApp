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
            .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.09))
            .foregroundColor(Color("DarkText"))
    }
}

struct InlineTitleView_Previews: PreviewProvider {
    static var previews: some View {
        InlineTitleView()
    }
}
