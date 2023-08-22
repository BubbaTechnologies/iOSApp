//
//  TextInputView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct TextInputView: View {
    var promptText: String
    @Binding var input: String
    var secure: Bool
    var body: some View {
        GeometryReader{ reader in
            SuperTextField(
                placeholder: Text(promptText),
                text: $input,
                secure: secure
            )
            .frame(width: reader.size.width * 0.8)
            .background(Color("LightBackgroundColor"))
            .border(Color("DarkText"))
            .cornerRadius(2.5)
            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.05, relativeTo: .body))
            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}

struct SuperTextField: View {
    var placeholder: Text
    @Binding var text: String
    var secure: Bool
    @FocusState var focusState:Bool
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                ZStack{
                    if secure {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                    }
                }
                .focused($focusState)
                .frame(width: reader.size.width * 0.9, height: reader.size.height)
                .minimumScaleFactor(0.5)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .border(.clear)
                if text.isEmpty {
                    placeholder
                    .background(Color.clear)
                    .onTapGesture {
                        focusState = true
                    }
                }
            }
            .foregroundColor(Color("DarkText"))
            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(promptText: "Email", input: .constant(""), secure: false)
    }
}
