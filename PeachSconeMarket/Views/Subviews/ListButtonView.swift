//
//  ListLabelView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/18/23.
//

import SwiftUI

struct ListButtonView: View {
    @State var selected: Bool = false
    public var item: String
    public let action: (String, Bool)->Void
    private let textScaleFactor: Double = 0.06
    
    
    var body: some View {
        Button() {
            action(item, selected)
            selected.toggle()
        } label: {
            HStack{
                Rectangle()
                    .stroke(Color("DarkText"), lineWidth: 1)
                    .overlay(
                        VStack{
                            Spacer()
                            if (selected) {
                                Text("X")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * (textScaleFactor - 0.01), relativeTo: .subheadline))
                                    .foregroundColor(Color("DarkText"))
                            }
                            Spacer()
                        }
                    ).frame(width: UIScreen.main.bounds.width * (textScaleFactor - 0.01), height: UIScreen.main.bounds.width * (textScaleFactor - 0.01))
                Text("\(item.capitalized.replacingOccurrences(of: "_", with: " "))")
                    .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * textScaleFactor, relativeTo: .subheadline))
                    .foregroundColor(Color("DarkText"))
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
        }
    }
}

struct ListButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ListButtonView(item: "Male", action:{(_,_) in return})
    }
}
