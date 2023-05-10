//
//  ContentView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct LoadingView: View {
    static let backgroundColor = Color("BackgroundColor")
    var body: some View {
        ZStack{
            LoadingView.backgroundColor.ignoresSafeArea()
            VStack(alignment: .center){
                Spacer()
                Text("Peach Scone Market")
                    .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.13))
                    .padding(.bottom, 5)
                //TODO: Integrate progess bar with loading
                ProgressView(value: 0.5)
                    .accentColor(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                Spacer()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
        LoadingView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
            .previewDisplayName("iPhone 14 Pro Max")
    }
}
