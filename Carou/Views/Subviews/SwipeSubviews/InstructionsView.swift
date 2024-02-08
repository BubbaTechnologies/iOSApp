//
//  InstructionsView.swift
//  Carou
//
//  Created by Matt Groholski on 2/7/24.
//

import SwiftUI

struct InstructionsView: View {
    
    @Binding var isPresent: Bool
    
    static var bottomFontSizeRatio: Double = 0.075
    
    var body: some View {
        GeometryReader { reader in
            Color(.gray).opacity(0.4).ignoresSafeArea()
                .onTapGesture {
                    self.isPresent = false
                }
            ZStack {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Tap to Dismiss")
                            .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * InstructionsView.bottomFontSizeRatio, relativeTo: .caption))
                            .foregroundColor(Color("DarkFontColor"))
                            .offset(y: reader.size.height * -0.2)
                        Spacer()
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "arrowshape.left.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: reader.size.height * 0.05)
                            .foregroundColor(Color("DarkFontColor"))
                        Text("Dislike")
                            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * InstructionsView.bottomFontSizeRatio, relativeTo: .caption))
                            .foregroundColor(Color("DarkFontColor"))
                        Spacer()
                        Text("Like")
                            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * InstructionsView.bottomFontSizeRatio, relativeTo: .caption))
                            .foregroundColor(Color("DarkFontColor"))
                        Image(systemName: "arrowshape.right.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: reader.size.height * 0.05)
                            .foregroundColor(Color("DarkFontColor"))
                    }
                    .padding(.horizontal, reader.size.width * 0.02)
                    Spacer()
                }
                VStack(alignment: .center){
                    Spacer()
                    HStack(alignment: .center){
                        Spacer()
                        VStack(spacing: reader.size.height * 0.01){
                            Text("Filters")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * InstructionsView.bottomFontSizeRatio, relativeTo: .caption))
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.bottom, 0)
                                .offset(y: reader.size.height * 0.02)
                            Image(systemName: "arrowshape.down.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * 0.05)
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.top, 0)
                                .contentMargins(0)
                                .rotationEffect(.degrees(-15))
                                .offset(x: reader.size.width * 0.025, y: reader.size.height * 0.015)
                        }
                        .frame(height: reader.size.height * 0.05)
                        Spacer()
                        VStack(spacing: reader.size.height * 0.01){
                            Text("Activity")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * InstructionsView.bottomFontSizeRatio, relativeTo: .caption))
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.bottom, 0)
                                .offset(y: reader.size.height * 0.02)
                            Image(systemName: "arrowshape.down.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * 0.05)
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.top, 0)
                                .contentMargins(0)
                                .rotationEffect(.degrees(08))
                                .offset(x: reader.size.width * -0.035, y: reader.size.height * 0.0125)
                        }
                        .frame(height: reader.size.height * 0.05)
                        Spacer()
                        VStack(spacing: reader.size.height * 0.01){
                            Text("Home")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * InstructionsView.bottomFontSizeRatio, relativeTo: .caption))
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.bottom, 0)
                                .offset(y: reader.size.height * 0.02)
                            Image(systemName: "arrowshape.down.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * 0.05)
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.top, 0)
                                .contentMargins(0)
                                .rotationEffect(.degrees(35))
                                .offset(x: reader.size.width * -0.1, y: reader.size.height * 0.015)
                        }
                        .frame(height: reader.size.height * 0.05)
                        Spacer()
                        VStack(spacing: reader.size.height * 0.01){
                            Text("Likes")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * InstructionsView.bottomFontSizeRatio, relativeTo: .caption))
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.bottom, 0)
                                .offset(y: reader.size.height * 0.02)
                            Image(systemName: "arrowshape.down.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * 0.05)
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.top, 0)
                                .rotationEffect(.degrees(45))
                                .offset(x: reader.size.width * -0.12, y: reader.size.height * 0.0175)
                        }
                        .frame(height: reader.size.height * 0.05)
                        Spacer()
                    }
                    .padding(.bottom, reader.size.height * 0.1)
                }
                VStack (alignment: .leading, spacing: 0){
                    HStack(spacing: 0){
                        VStack(spacing: reader.size.height * 0.01){
                            Image(systemName: "arrowshape.up.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * 0.05)
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.top, 0)
                                .rotationEffect(.degrees(-35))
                                .offset(x: reader.size.width * 0.02,  y: reader.size.height * -0.025)
                            Text("Profile")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * InstructionsView.bottomFontSizeRatio, relativeTo: .caption))
                                .foregroundColor(Color("DarkFontColor"))
                                .padding(.leading, reader.size.width * 0.05)
                                .offset(x: reader.size.width * 0.12, y: reader.size.height * -0.035)
                        }
                        Spacer()
                    }
                    .offset(y: reader.size.height * 0.075)
                    Spacer()
                }
            }
        }
    }
}

struct DownArrowSubView: View {
    var displayText: String
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center){
                Spacer()
                Text("\(displayText)")
                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.35, relativeTo: .caption))
                    .foregroundColor(Color("DarkFontColor"))
                Image(systemName: "arrowshape.down.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: reader.size.width * 0.8, height: reader.size.height)
                    .foregroundColor(Color("DarkFontColor"))
                Spacer()
            }
            .frame(width: reader.size.width, height: reader.size.height)
        }
    }
}

#Preview {
    InstructionsView(isPresent: .constant(true))
}
