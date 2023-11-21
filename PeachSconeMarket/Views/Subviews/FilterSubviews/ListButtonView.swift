//
//  ListLabelView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/18/23.
//

import SwiftUI

struct ListButtonView: View {
    @Binding var selected: Bool
    public var item: String
    public var action: (String, Bool)->Void
    private let textScaleFactor: Double = 0.07
    
    
    var body: some View {
        GeometryReader { reader in
            HStack{
                Spacer()
                Button() {
                    selected.toggle()
                    action(item, selected)
                } label: {
                    HStack{
                        Circle()
                            .stroke(Color("DarkFontColor"), lineWidth: 1)
                            .overlay(
                                VStack{
                                    Spacer()
                                    if (selected) {
                                        Circle()
                                            .foregroundColor(Color("DarkFontColor"))
                                            .frame(height: reader.size.height * 0.45)
                                    }
                                    Spacer()
                                }
                            ).frame(height: reader.size.height * 0.45)
                        Text("\(item.replacingOccurrences(of: "_", with: " ").capitalized)")
                            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * textScaleFactor, relativeTo: .subheadline))
                            .foregroundColor(Color("DarkFontColor"))
                        Spacer()
                    }
                }.padding(.leading, reader.size.width * 0.02)
                Spacer()
            }.frame(width: reader.size.width, alignment: .leading)
        }
    }
}

struct ListButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ListButtonView(selected: .constant(false), item: "Male", action: {_,_ in return})
    }
}
