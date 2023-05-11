//
//  NavigationButtonView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct NavigationButtonView: View {
    private var scaleFactor: Double = 0.12
    private var padding: Double = 3.0
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: switchView) {
                Circle()
                    .fill(Color("DarkBackgroundColor"))
            }.frame(width: UIScreen.main.bounds.width * scaleFactor, height: UIScreen.main.bounds.height * scaleFactor)
                .overlay(
                    Image("HeartIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * (scaleFactor - 0.02), height: UIScreen.main.bounds.height * (scaleFactor - 0.02))
                )
                .padding(.horizontal, padding)
            Button(action: switchView) {
                Circle()
                    .fill(Color("DarkBackgroundColor"))
            }.frame(width: UIScreen.main.bounds.width * scaleFactor, height: UIScreen.main.bounds.height * scaleFactor)
                .overlay(
                    Image("SwipeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * (scaleFactor - 0.04), height: UIScreen.main.bounds.height * (scaleFactor - 0.04))
                )
                .padding(.horizontal, padding)
            Button(action: switchView) {
                Circle()
                    .fill(Color("DarkBackgroundColor"))
            }.frame(width: UIScreen.main.bounds.width * scaleFactor, height: UIScreen.main.bounds.height * scaleFactor)
                .overlay(
                    Image("BagIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * (scaleFactor - 0.035), height: UIScreen.main.bounds.height * (scaleFactor - 0.035))
                )
                .padding(.horizontal, padding)
            Spacer()
        }
    }
}

extension NavigationButtonView {
    func switchView() {
        //TODO: Create function to switch views
    }
}

struct NavigationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButtonView()
    }
}
