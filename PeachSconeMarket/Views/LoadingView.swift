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
                    .padding(.bottom, 5)
                //TODO: Integrate progess bar with loading
                ProgressView(value: 0.5)
                    .accentColor(Color("DarkText"))
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                Spacer()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
//        LoadingView()
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
//            .previewDisplayName("iPhone 14 Pro Max")
    }
}
