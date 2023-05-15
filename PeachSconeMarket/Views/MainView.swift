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
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center){
                if state == .main {
                    SwipeView(items: $items)
                } else if state == .likes {
                    LikesView()
                } else if state == .collection {
                    CollectionView()
                }
                Spacer()
                NavigationButtonView(state: $state)
                    .frame(height: UIScreen.main.bounds.height * 0.03)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.01)
            }
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
    }
}
