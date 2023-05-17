//
//  MainView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/12/23.
//

import SwiftUI

struct MainView: View {
    @State var state:pageState = .main
    @Binding var items:[ClothingItem]
    @State var isPresentingSafari:Bool = false
    @State var safariUrl: URL = URL(string: "https://www.peachsconemarket.com")!
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center){
                if state == .main {
                    SwipeView(items: $items)
                } else if state == .likes {
                    LikesView(isPresentingSafari: $isPresentingSafari, safariUrl: $safariUrl)
                } else if state == .collection {
                    CollectionView()
                }
                Spacer()
                NavigationButtonView(state: $state)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.0025)
                    .frame(height: UIScreen.main.bounds.height * 0.055)
            }
        }.sheet(isPresented: $isPresentingSafari) {
            SafariView(url: $safariUrl)
        }
    }
}

enum pageState {
    case likes
    case main
    case collection
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(items: .constant(ClothingItem.sampleItems))
        MainView(items: .constant(ClothingItem.sampleItems))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}
