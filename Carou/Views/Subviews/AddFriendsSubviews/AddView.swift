//
//  AddView.swift
//  Carou
//
//  Created by Matt Groholski on 1/23/24.
//

import SwiftUI

struct AddView: View {
    var username: String
    var buttonAction: (Bool)->Void
    var usernameTapAction: ()->Void
    
    @State var confirmed: Bool = true
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center){
                Spacer()
                HStack(alignment: .center) {
                    HStack{
                        Text("\(username)")
                            .font(CustomFontFactory.getFont(style: "regular", size: reader.size.width * 0.075, relativeTo: .caption2))
                            .foregroundColor(Color("DarkFontColor"))
                            .padding(.leading, reader.size.width * 0.1)
                        Spacer()
                    }.onTapGesture {
                        usernameTapAction()
                    }
                    Button(action: {
                        confirmed.toggle()
                        buttonAction(confirmed)
                    }) {
                        if !confirmed {
                            Image(systemName:"plus")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("ConfirmationColor"))
                                .frame(height: reader.size.width * 0.065)
                        } else {
                            Image(systemName:"checkmark")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("DarkFontColor"))
                                .frame(height: reader.size.width * 0.065)
                        }
                    }
                    .padding(.trailing, reader.size.width * 0.02)
                    .padding(.trailing, reader.size.width * 0.1)

                    //                Button(action: {denyAction()}) {
                    //                    Text("X")
                    //                        .font(CustomFontFactory.getFont(style: "regular", size: reader.size.width * 0.05, relativeTo: .caption2))
                    //                        .foregroundColor(.red)
                    //                        .frame(height: reader.size.height * 0.1)
                    //                }
                    //                .padding(.trailing, reader.size.width * 0.1)
                }
                .frame(width: reader.size.width, height: reader.size.height * 0.8)
                Spacer()
                Divider()
                    .frame(width: reader.size.width * 0.9)
            }.frame(height: reader.size.height)
                .padding(.vertical, 0)
        }
    }
}

#Preview {
    AddView(username: "mgroholski", buttonAction: {_ in}, usernameTapAction: {})
}
