//
//  ButtonView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var action: () -> Void
    
    @State private var loading: Bool = false
    @State private var displayText: String = ""
    
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                Button(displayText) {
                    displayText = ""
                    loading = true
                    DispatchQueue.global().async {
                        action()
                        
                        DispatchQueue.main.async {
                            loading = false
                            displayText = text
                        }
                    }
                }
                    .buttonStyle(.plain)
                    .foregroundColor(Color("LightText"))
                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.08, relativeTo: .title3))
                    .frame(width: reader.size.width * 0.33, height: reader.size.height)
                    .background(Color("DarkText"))
                    .cornerRadius(5.0)
                    .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
                    .disabled(loading)
                    .onAppear{
                        displayText = text
                    }
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("LightText")))
                }
            }
        }
    }
}

struct SmallButtonView: View {
    var text: String
    var action: () -> Void
    
    @State private var loading: Bool = false
    @State private var displayText: String = ""
    
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                Button(displayText){
                    displayText = ""
                    loading = true
                    DispatchQueue.global().async {
                        action()
                        
                        DispatchQueue.main.async {
                            loading = false
                            displayText = text
                        }
                    }
                }
                    .foregroundColor(Color("LightText"))
                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .caption))
                    .background(Color("DarkText"))
                    .disabled(loading)
                    .cornerRadius(5.0)
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("LightText")))
                }
            }
            .frame(width: reader.size.width * 0.22, height: reader.size.height * 0.04)
            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Sign In", action: {() -> Void in return})
        SmallButtonView(text: "Cancel", action: {() -> Void in return})
    }
}
