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
    
    var fontFactor: CGFloat = 0.08
    var relativeToValue: Font.TextStyle = .title3
    var widthFactor: CGFloat = 0.33
    
    @State private var loading: Bool = false
    @State private var displayText: String = ""
    
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                Button(displayText) {
                    displayText = ""
                    loading = true
                    DispatchQueue.global().async {
                        action()
                        
                        DispatchQueue.global().async {
                            action()
                            loading = false
                            displayText = text
                        }
                    }
                }
                    .buttonStyle(.plain)
                    .foregroundColor(Color("LightText"))
                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.08, relativeTo: relativeToValue))
                    .frame(width: reader.size.width * 0.33, height: reader.size.height)
                    .background(Color("DarkText"))
                    .cornerRadius(5.0)
                    .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
                    .disabled(loading)
                    .onAppear{
                        displayText = text
                    }
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("LightText")))
                }
            }
        }
    }
}

struct SmallButtonView: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        ButtonView(text: text, action: action, fontFactor: 0.04, relativeToValue: .caption, widthFactor: 0.22)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Sign In", action: {() -> Void in return})
        SmallButtonView(text: "Cancel", action: {() -> Void in return})
    }
}
