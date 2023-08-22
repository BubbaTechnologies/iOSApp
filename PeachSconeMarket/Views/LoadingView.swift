//
//  ContentView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            GeometryReader{ reader in
                Color("BackgroundColor").ignoresSafeArea()
                VStack(alignment: .center){
                    Spacer()
                    TitleView()
                        .frame(height: max(125, reader.size.height * 0.2))
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                        .scaleEffect(2)
                    Spacer()
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
