//
//  MainView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/12/23.
//

import SwiftUI

struct MainView: View {
    /**
                Controls the scene phase, when the user is active or inactivate. @Enviroment stores accesses enviroment variable within scene.
     */
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject var api:Api
    @ObservedObject var swipeClothingManager: ClothingListManager
    @ObservedObject var store: LikeStore
        
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
                                pageState = previousPageState
                            } else if newState == .editing {
                                pageState = previousPageState
                                swipeClothingManager.reset()
                                
                                //confirm
                                DispatchQueue.global(qos: .userInitiated).async {
                                    do {
                                        try swipeClothingManager.loadItems()
                                    } catch {
                                        print("\(error)")
                                    }
                                }
                            } else {
                                pageState = newState
                            }
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .swipe {
                        SwipeView(api: api, clothingManager: swipeClothingManager, store: store, pageState: $pageState) { newState in
                            previousPageState = pageState
                            pageState = newState
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .likes {
                        LikesView(clothingManager: ClothingPageManager(api: api, requestType: .likes),likeStore: store, pageState: $pageState){ newState in
                            previousPageState = pageState
                            pageState = newState
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .closet {
                        //Loads bought items (api references as collection)
                        ClosetView(clothingManager: ClothingPageManager(api: api, requestType: .collection), likeStore: store, pageState: $pageState) { newState in
                            previousPageState = pageState
                            pageState = newState
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    }
                    Spacer()
                }
            }
        }.onChange(of: scenePhase) { phase in
            //Persists likes when user is inactive
            if phase == .inactive {
                Task {
                    do {
                        try await self.store.save()
                    } catch {
                        print("Could not persist likes: \(store.likes)")
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(api: Api(), swipeClothingManager: ClothingListManager(), store: LikeStore())
        MainView(api: Api(), swipeClothingManager: ClothingListManager(), store: LikeStore())
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}

enum PageState {
    case likes
    case swipe
    case closet
    case filtering
    case editing
}
