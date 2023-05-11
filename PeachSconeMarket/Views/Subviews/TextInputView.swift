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
    var body: some View {
        SuperTextField(
            placeholder: Text(promptText),
            text: $input
        )
        .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * 0.08))
        .foregroundColor(Color("DarkText"))
        .border(Color("DarkText"))
        .background(Color("LightBackgroundColor"))
        .disableAutocorrection(true)
        .cornerRadius(2.5)
    }
}

struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06)
        }
    }
    
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(promptText: "Email", input: .constant(""))
    }
}
