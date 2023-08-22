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
        GeometryReader { reader in
            SuperPicker(
                placeholder: promptText, selection: $selection, options: options, selected: $selected
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

struct SuperPicker: View {
    
    var placeholder: String
    @Binding var selection: String
    var options:[String]
    @Binding var selected: Bool
    
    var body: some View {
        GeometryReader { reader in
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
                            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.06, relativeTo: .body))
                            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
                    }
                    .foregroundColor(Color("DarkText"))
                }
            }
        }
    }
    
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(selection: .constant("Male"), promptText: "Gender", options:["Male","Female","Other"], selected: .constant(false))
    }
}
