//
//  DynamicButtonView.swift
//  Carou
//
//  Created by Matt Groholski on 1/23/24.
//

import SwiftUI

struct DynamicButtonView: View {
    @Binding var text: String
    var confirmation: Bool = false
    var action: () -> Void
    
    var fontFactor: CGFloat = 0.08
    var relativeToValue: Font.TextStyle = .title3
    var widthFactor: CGFloat = 0.33
    
    @State private var loading: Bool = false
    @State private var displayText: String = ""
    
    @State private var confirmationState: Bool = false
    @State private var buttonBackgroundColor: Color = Color("DarkFontColor")
    
    init(text: Binding<String>, action: @escaping ()->Void) {
        self._text = text
        self.action = action
    }
    
    init (text: Binding<String>, widthFactor: CGFloat, action: @escaping ()->Void) {
        self._text = text
        self.widthFactor = widthFactor
        self.action = action
    }
    
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

extension DynamicButtonView{
    init (text: Binding<String>, confirmation: Bool, widthFactor: Double, action: @escaping ()->Void) {
        self._text = text
        self.action = action
        self.widthFactor = widthFactor
        self.confirmation = confirmation
    }
    
    init (text: Binding<String>, confirmation: Bool, widthFactor: Double, fontFactor: Double, action: @escaping ()->Void) {
        self._text = text
        self.action = action
        self.widthFactor = widthFactor
        self.fontFactor = fontFactor
        self.confirmation = confirmation
    }
}

struct DyanmicButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicButtonView(text: .constant("Sign In"), action: {() -> Void in return})
    }
}

