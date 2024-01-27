//
//  NavigationButtonView.swift
//  Carou
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct NavigationButtonView: View {
    @Binding var auxiliary: (AuxiliaryType, AuxiliaryType)
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
                    if auxiliary.0 != .none {
                        Button(action: {buttonAction(.auxiliary(auxiliary.0))}) {
                            Circle()
                                .fill(Color("DarkBackgroundColor"))
                                .overlay(
                                    ZStack{
                                        getAuxiliaryView(type: auxiliary.0, reader: reader)
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
                
                //Activity View Button
                Button(action: {buttonAction(.activity)}) {
                    Circle()
                        .fill(Color("DarkBackgroundColor"))
                        .overlay(
                            GeometryReader { reader in
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(height: reader.size.height * 0.6)
                                    .position(x: reader.frame(in: .local).midX * 1.035, y: reader.frame(in: .local).midY * 1.034)
                            }
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
                    if auxiliary.1 != .none {
                        Button(action: {buttonAction(.auxiliary(auxiliary.1))}) {
                            Circle()
                                .fill(Color("DarkBackgroundColor"))
                                .overlay(
                                    ZStack{
                                        getAuxiliaryView(type: auxiliary.1, reader: reader)
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

extension NavigationButtonView {
    /**
        - Description: Returns view for auxiliary button type.
        - Parameters:
            - type: The Auxiliary Type requested.
     */
    func getAuxiliaryView(type: AuxiliaryType, reader: GeometryProxy) -> some View {
        switch type {
        case .none:
            return AnyView(EmptyView())
        case .filtering:
            return AnyView(Image("FilterIcon")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("DarkFontColor"))
                .frame(height: reader.size.height * ((scaleFactor - 0.4) * 0.75)))
        case .editing:
            return AnyView(Image("EditIcon")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("DarkFontColor"))
                .frame(height: reader.size.height * ((scaleFactor - 0.25) * 0.75))
                .offset(y: reader.size.height * -0.0015))
        case .adding:
            //TODO: Create adding icon
            return AnyView(Text("+")
                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.15, relativeTo: .body))
                .foregroundColor(Color("DarkFontColor")))
        case .cancel:
            return AnyView(Text("X")
                        .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.0825, relativeTo: .body))
                        .foregroundColor(Color("DarkFontColor")))
        case .confirm:
            return AnyView(Image(systemName:"checkmark")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("DarkFontColor"))
                .frame(height: reader.size.height * ((scaleFactor - 0.3) * 0.75))
                .offset(x: reader.size.width * -0.001))
        }
    }
}

struct NavigationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButtonView(auxiliary: .constant((.cancel, .confirm)), buttonAction: {_ in return})
    }
}
