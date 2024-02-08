//
//  MainView.swift
//  Carou
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
    @ObservedObject var instanceDataStore: InstanceDataStore
        
    @State var pageState:PageState = .swipe
    @State var previousPageState: PageState = .swipe
    
    var body: some View {
        ZStack{
            GeometryReader { reader in
                Color("BackgroundColor").ignoresSafeArea()
                VStack(alignment: .center){
                    if case .auxiliary(let auxiliaryType) = pageState {
                        if auxiliaryType == .filtering {
                                FilterView(api: api) { newState in
                                    if newState == .auxiliary(.cancel) {
                                        pageState = previousPageState
                                    } else if newState == .auxiliary(.confirm) {
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
                                    switchFunction(newState: newState)
                                }
                                .frame(width: reader.size.width, height: reader.size.height)
                        } else if auxiliaryType == .adding {
                            AddFriendsView(api: self.api) { newState in
                                previousPageState = pageState
                                pageState = newState
                                switchFunction(newState: newState)
                            }
                            .frame(width: reader.size.width, height: reader.size.height)
                        }
                    } else if pageState == .swipe {
                        SwipeView(api: api, clothingManager: swipeClothingManager, likeStore: store, instanceDataStore: instanceDataStore, initials: api.profileInformation.getInitials(), pageState: $pageState) { newState in
                            previousPageState = pageState
                            pageState = newState
                            switchFunction(newState: newState)
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .likes {
                        LikesView(clothingManager: ClothingPageManager(api: api, requestType: .likes),likeStore: store, pageState: $pageState){ newState in
                            previousPageState = pageState
                            pageState = newState
                            switchFunction(newState: newState)
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .closet {
                        //Loads bought items (api references as collection)
                        ClosetView(clothingManager: ClothingPageManager(api: api, requestType: .collection), likeStore: store, pageState: $pageState) { newState in
                            previousPageState = pageState
                            pageState = newState
                            switchFunction(newState: newState)
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .profile {
                        ProfileView(api: api) { newState in
                            previousPageState = pageState
                            pageState = newState
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    } else if pageState == .activity {
                        ActivityView(activityManager: ActivityManager(api: api), pageState: $pageState, likeStore: store) { newState in
                            previousPageState = pageState
                            pageState = newState
                            switchFunction(newState: newState)
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                    }
                    Spacer()
                }
            }
        }.onChange(of: scenePhase) { oldPhase, newPhase in
            //Persists likes when user is inactive
            if newPhase == .inactive {
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

extension MainView {
    func loadFilterOptions(page: Api.FilterType) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.api.loadFilterOptions(type: page)
            } catch {
                fatalError("Error while loading filter options. ErrorMessage: \(error)")
            }
        }
    }
    
    /**
            - Description: Executes at the end of each state switch except profile.
            - Parameters:
                - newState: The new pageState.
     */
    func switchFunction(newState: PageState) {
        //Loads new filter options
        switch newState {
        case .likes:
            api.resetFilters()
            loadFilterOptions(page: .likes)
            break;
        case .swipe:
            api.resetFilters()
            loadFilterOptions(page: .general)
            break;
        case .activity:
            api.resetFilters()
            loadFilterOptions(page: .activity)
            break;
        default:
             break
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(api: Api(), swipeClothingManager: ClothingListManager(), store: LikeStore(), instanceDataStore: InstanceDataStore(displayInstructions: false))
        MainView(api: Api(), swipeClothingManager: ClothingListManager(), store: LikeStore(), instanceDataStore: InstanceDataStore(displayInstructions: false))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}

