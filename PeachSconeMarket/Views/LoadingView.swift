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
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center){
                Spacer()
                TitleView()
                    .padding(.bottom, 10)
                    .frame(width: UIScreen.main.bounds.width * 0.85)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                    .scaleEffect(2)
                Spacer()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
