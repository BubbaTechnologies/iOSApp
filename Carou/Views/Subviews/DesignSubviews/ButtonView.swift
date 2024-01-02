//
//  ButtonView.swift
//  Carou
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var confirmation: Bool = false
    var action: () -> Void
    
    var fontFactor: CGFloat = 0.08
    var relativeToValue: Font.TextStyle = .title3
    var widthFactor: CGFloat = 0.33
    
    @State private var loading: Bool = false
    @State private var displayText: String = ""
    
    @State private var confirmationState: Bool = false
    @State private var buttonBackgroundColor: Color = Color("DarkFontColor")
    
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                Button(displayText) {
                    if confirmation && !confirmationState {
                        self.confirmationState = true
                        self.buttonBackgroundColor = Color("ConfirmationColor")
                        self.displayText = "Confirm"
                    } else if !confirmation || confirmationState {
                        displayText = ""
                        loading = true
                        DispatchQueue.global(qos: .userInitiated).async {
                            action()
                            DispatchQueue.main.async {
                                loading = false
                                displayText = text
                            }
                        }
                    }
                }
                    .buttonStyle(.plain)
                    .foregroundColor(Color("LightFontColor"))
                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * fontFactor, relativeTo: relativeToValue))
                    .frame(width: reader.size.width * widthFactor, height: reader.size.height)
                    .background(buttonBackgroundColor)
                    .cornerRadius(5.0)
                    .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
                    .disabled(loading)
                    .onAppear{
                        displayText = text
                    }
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("LightFontColor")))
                }
            }
        }
    }
}

extension ButtonView{
    init (text: String, confirmation: Bool, widthFactor: Double, action: @escaping ()->Void) {
        self.text = text
        self.action = action
        self.widthFactor = widthFactor
        self.confirmation = confirmation
    }
    
    init (text: String, confirmation: Bool, widthFactor: Double, fontFactor: Double, action: @escaping ()->Void) {
        self.text = text
        self.action = action
        self.widthFactor = widthFactor
        self.fontFactor = fontFactor
        self.confirmation = confirmation
    }
}

struct SmallButtonView: View {
    var text: String
    var confirmation: Bool
    var action: () -> Void
    
    var body: some View {
        ButtonView(text: text, confirmation: confirmation, action: action, fontFactor: 0.04, relativeToValue: .caption, widthFactor: 0.22)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Sign In", confirmation: true, action: {() -> Void in return})
        SmallButtonView(text: "Cancel", confirmation: false, action: {() -> Void in return})
    }
}
