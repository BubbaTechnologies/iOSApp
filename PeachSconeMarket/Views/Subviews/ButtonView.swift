//
//  ButtonView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(text, action: action)
            .frame(width: UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.06)
            .foregroundColor(Color("LightText"))
            .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * 0.08, relativeTo: .title3))
            .background(Color("DarkText"))
            .cornerRadius(5.0)
    }
}

struct SmallButtonView: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(text, action: action)
            .frame(width: UIScreen.main.bounds.width * 0.22, height: UIScreen.main.bounds.height * 0.04)
            .foregroundColor(Color("LightText"))
            .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * 0.04, relativeTo: .caption))
            .background(Color("DarkText"))
            .cornerRadius(5.0)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Sign In", action: {() -> Void in return})
        SmallButtonView(text: "Cancel", action: {() -> Void in return})
    }
}
