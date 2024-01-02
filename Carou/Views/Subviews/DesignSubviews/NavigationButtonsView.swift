//
//  NavigationButtonView.swift
//  Carou
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct NavigationButtonView: View {
    var showFilter: Bool
    var showEdit: Bool
    @Binding var options: Bool
    let buttonAction: (PageState)->Void
    
    private let scaleFactor: Double = 0.7
    private let padding: Double = 2.5
    private let heightPadding: Double = 0.0025
    
    var body: some View {
        GeometryReader { reader in
            HStack{
                Spacer()
                //Exit/Filter Button
                ZStack{
                    if (showFilter || options) {
                        Button(action: {buttonAction(.filtering)}) {
                            Circle()
                                .fill(Color("DarkBackgroundColor"))
                                .overlay(
                                    ZStack{
                                        if (options) {
                                            Text("X")
                                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.08, relativeTo: .body))
                                                .foregroundColor(Color("DarkFontColor"))
                                        } else {
                                            Image("FilterIcon")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color("DarkFontColor"))
                                                .frame(height: reader.size.height * ((scaleFactor - 0.4) * 0.75))
                                        }
                                    }
                                )
                        }
                    } else  {
                        Circle()
                            .opacity(0)
                    }
                }.frame(height: reader.size.height * (scaleFactor * 0.75))
                    .padding(.horizontal, (padding))
                    .padding(.top, reader.size.height * heightPadding)
                
                //Collection View Button
                Button(action: {buttonAction(.settings)}) {
                    Circle()
                        .fill(Color("DarkBackgroundColor"))
                        .overlay(
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.black)
                                .frame(height: reader.size.height * (scaleFactor - 0.2))
                        )
                }.frame(height: reader.size.height * scaleFactor)
                    .padding(.horizontal, padding)
                
                //Swipe View Button
                Button(action: {buttonAction(.swipe)}) {
                    Circle()
                        .fill(Color("DarkBackgroundColor"))
                        .overlay(
                            Image("SwipeIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * (scaleFactor - 0.22))
                        )
                }.frame(height: reader.size.height * scaleFactor)
                    .padding(.horizontal, padding)
                    
                
                //Likes View Button
                Button(action: {buttonAction(.likes)}) {
                    Circle()
                        .fill(Color("DarkBackgroundColor"))
                        .overlay(
                            Image("HeartIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * (scaleFactor - 0.125))
                                .offset(y: reader.size.height * 0.015)
                        )

                }.frame(height: reader.size.height * scaleFactor)
                    .padding(.horizontal, padding)
                    
                
                //Confirm/Edit Button
                ZStack{
                    if (showEdit || options) {
                        Button(action: {buttonAction(.editing)}) {
                            Circle()
                                .fill(Color("DarkBackgroundColor"))
                                .overlay(
                                    ZStack{
                                        if (options) {
                                            Image(systemName:"checkmark")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color("DarkFontColor"))
                                                .frame(height: reader.size.height * ((scaleFactor - 0.3) * 0.75))
                                                .offset(x: reader.size.width * -0.001)
                                        } else {
                                            Image("EditIcon")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color("DarkFontColor"))
                                                .frame(height: reader.size.height * ((scaleFactor - 0.25) * 0.75))
                                                .offset(y: reader.size.height * -0.0015)
                                        }
                                    }
                                )

                        }
                    } else {
                        Circle()
                            .opacity(0)
                    }
                }.frame(height: reader.size.height * (scaleFactor * 0.75))
                    .padding(.horizontal, padding)
                    .padding(.top, reader.size.height * heightPadding)
                Spacer()
            }.position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY - reader.size.height * 0.05)
        }
    }
}

struct NavigationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButtonView(showFilter: true, showEdit: true, options: .constant(false), buttonAction: {_ in return})
    }
}
