//
//  NavigationButtonView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct NavigationButtonView: View {
    @Binding public var state:pageState
    private let scaleFactor: Double = 0.12
    private let padding: Double = 3.0
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: switchLikesView) {
                Circle()
                    .fill(Color("DarkBackgroundColor"))
                    .overlay(
                        Image("HeartIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * (scaleFactor - 0.03), height: UIScreen.main.bounds.height * (scaleFactor - 0.03))
                    )
                
            }.frame(width: UIScreen.main.bounds.width * scaleFactor, height: UIScreen.main.bounds.height * scaleFactor)
                .padding(.horizontal, padding)
            Button(action: switchMainView) {
                Circle()
                    .fill(Color("DarkBackgroundColor"))
                    .overlay(
                        Image("SwipeIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * (scaleFactor - 0.05), height: UIScreen.main.bounds.height * (scaleFactor - 0.05))
                    )
            }.frame(width: UIScreen.main.bounds.width * scaleFactor, height: UIScreen.main.bounds.height * scaleFactor)
                .padding(.horizontal, padding)
            Button(action: switchCollectionView) {
                Circle()
                    .fill(Color("DarkBackgroundColor"))
                    .overlay(
                        Image("BagIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * (scaleFactor - 0.04), height: UIScreen.main.bounds.height * (scaleFactor - 0.04))
                    )
            }.frame(width: UIScreen.main.bounds.width * scaleFactor, height: UIScreen.main.bounds.height * scaleFactor)
                .padding(.horizontal, padding)
            Spacer()
        }
    }
}

extension NavigationButtonView {
    func switchLikesView() {
        state = .likes
    }
    
    func switchMainView() {
        state = .main
    }
    
    func switchCollectionView() {
        state = .collection
    }
}

struct NavigationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButtonView(state: .constant(.main))
    }
}
