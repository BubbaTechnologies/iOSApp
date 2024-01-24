//
//  AddView.swift
//  Carou
//
//  Created by Matt Groholski on 1/23/24.
//

import SwiftUI

struct AddView: View {
    var username: String
    var addAction: ()->Void
    var denyAction: ()->Void
    
    var body: some View {
        GeometryReader { reader in
            HStack(alignment: .center) {
                Text("\(username)")
                    .font(CustomFontFactory.getFont(style: "regular", size: reader.size.width * 0.075, relativeTo: .caption2))
                    .foregroundColor(Color("DarkFontColor"))
                    .padding(.leading, reader.size.width * 0.1)
                Spacer()
                Button(action: {addAction()}) {
                    Image(systemName:"plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("ConfirmationColor"))
                        .frame(height: reader.size.height * 0.6)
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
            .frame(width: reader.size.width)
        }
    }
}

#Preview {
    AddView(username: "mgroholski", addAction: {}, denyAction: {})
}
