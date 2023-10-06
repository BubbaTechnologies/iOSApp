//
//  ContentView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct LoadingView: View {
    var versionNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    var body: some View {
        ZStack{
            GeometryReader{ reader in
                Color("BackgroundColor").ignoresSafeArea()
                VStack(alignment: .center){
                    Spacer()
                    TitleView()
                        .frame(height: max(125, reader.size.height * 0.2))
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                        .scaleEffect(2)
                    Spacer()
                    Text("Version: \(versionNumber)")
                        .font(CustomFontFactory.getFont(style: "Regular", size: 18, relativeTo: .body))
                        .foregroundColor(Color("DarkFontColor"))
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
