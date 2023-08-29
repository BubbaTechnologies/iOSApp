//
//  MainView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/12/23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var api:Api
    @ObservedObject var swipeClothingManager: ClothingListManager
        
    @State var pageState:PageState = .swipe
    @State var previousPageState: PageState = .swipe
    
    var body: some View {
        ZStack{
            GeometryReader { reader in
                Color("BackgroundColor").ignoresSafeArea()
                VStack(alignment: .center){
                    if pageState == .filtering {
                        FilterView(api: api) { newState in
                            if newState == .filtering {
                                //cancel
                                pageState = previousPageState
                            } else if newState == .editing {
                                //confirm
                                pageState = previousPageState
                                swipeClothingManager.reset()
                                do {
                                    try swipeClothingManager.loadItems()
                                } catch {
                                    //TODO: Display error
                                }
                            }
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .swipe {
                        SwipeView(api: api, clothingManager: swipeClothingManager, pageState: $pageState) { newState in
                            previousPageState = pageState
                            pageState = newState
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .likes {
                        LikesView(clothingManager: ClothingPageManager(api: api, requestType: .likes), pageState: $pageState){ newState in 
                            previousPageState = pageState
                            pageState = newState
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .collection {
                        CollectionView(changeFunction: { newState in
                            previousPageState = pageState
                            pageState = newState
                        })
                        .frame(width: reader.size.width, height: reader.size.height)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(api: Api(), swipeClothingManager: ClothingListManager())
        MainView(api: Api(), swipeClothingManager: ClothingListManager())
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}

enum PageState {
    case likes
    case swipe
    case collection
    case filtering
    case editing
}
