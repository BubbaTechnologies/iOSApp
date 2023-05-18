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
    @State var editing: Bool = false
    @State var selectedItems:[Int] = []
    @State var collectionItems: [ClothingItem] = []
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center){
                if state == .main {
                    SwipeView(items: $items)
                } else if state == .likes {
                    LikesView(items: $collectionItems, selectedItems: $selectedItems ,isPresentingSafari: $isPresentingSafari, safariUrl: $safariUrl, editing: $editing)
                } else if state == .collection {
                    CollectionView()
                } else if state == .filter {
                    //TODO
                }
                Spacer()
                NavigationButtonView(showEdit: false, showFilter: true, state: $state, editing: $editing, selectedItems: $selectedItems, collectionItems: $collectionItems)
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
    case filter
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(items: .constant(ClothingItem.sampleItems))
        MainView(items: .constant(ClothingItem.sampleItems))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}
