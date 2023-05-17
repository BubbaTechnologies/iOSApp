//
//  PickerView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/11/23.
//

import SwiftUI

struct PickerView: View {
    @Binding var selection: String
    var promptText: String
    var options:[String]
    @Binding var selected: Bool
    
    var body: some View {
        SuperPicker(
            placeholder: promptText, selection: $selection, options: options, selected: $selected
        )
        .border(Color("DarkText"))
        .background(Color("LightBackgroundColor"))
        .disableAutocorrection(true)
        .cornerRadius(2.5)
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06)
        .padding(.bottom, 8)
    }
}

struct SuperPicker: View {
    
    var placeholder: String
    @Binding var selection: String
    var options:[String]
    @Binding var selected: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                Menu {
                    ForEach(options.reversed(), id: \.self) { option in
                        Button {
                            selection = option
                            selected = true
                        } label : {
                            Text(option)
                        }
                    }
                } label : {
                    Text(!selected ? placeholder : selection)
                        .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * 0.08, relativeTo: .body))
                }
                .foregroundColor(Color("DarkText"))
            }
            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06)
        }
    }
    
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(selection: .constant("Male"), promptText: "Gender", options:["Male","Female","Other"], selected: .constant(false))
    }
}
