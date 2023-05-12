//
//  ContentView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct LoadingView: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center){                
                Spacer()
                TitleView()
                    .padding(.bottom, 5)
                ProgressView(value: progress)
                    .accentColor(Color("DarkText"))
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                Spacer()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(progress: .constant(0.5))
//        LoadingView()
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
//            .previewDisplayName("iPhone 14 Pro Max")
    }
}
