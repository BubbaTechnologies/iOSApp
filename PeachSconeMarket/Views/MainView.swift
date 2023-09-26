//
//  MainView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/12/23.
//

import SwiftUI

struct MainView: View {
<<<<<<< HEAD
    @State var state:pageState = .main
    @Binding var items:[ClothingItem]
    @Binding var preLoadAmount: Int
    @State var isPresentingSafari:Bool = false
    @State var safariUrl: URL = URL(string: "https://www.peachsconemarket.com")!
    @State var editing: Bool = false
    @State var selectedItems:[Int] = []
    @State var collectionPaginator: ClothingItemPaginator = ClothingItemPaginator(requestType: .likes)
    @State var filtering: Bool = false
    @State var typeFilter: [String] = []
    @State var genderFilter: String = ""
    
    @State private var previousTypeFilter: [String] = []
    @State private var previousGenderFilter: String = ""
    
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center){
                if filtering {
                    FilterView(typeFilter: $typeFilter, genderFilter: $genderFilter)
                } else if state == .main {
                    SwipeView(items: $items, typeFilter: $typeFilter, genderFilter: $genderFilter, preLoadAmount: $preLoadAmount)
                } else if state == .likes {
                    LikesView(paginator: collectionPaginator, selectedItems: $selectedItems ,isPresentingSafari: $isPresentingSafari, safariUrl: $safariUrl, editing: $editing)
                } else if state == .collection {
                    CollectionView()
                }
                Spacer()
                NavigationButtonView(showEdit: false, showFilter: true, state: $state, editing: $editing, selectedItems: $selectedItems, paginator: collectionPaginator, filtering: $filtering, filterActions: filterActions)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.0025)
                    .frame(height: UIScreen.main.bounds.height * 0.055)
            }
        }.sheet(isPresented: $isPresentingSafari) {
            SafariView(url: $safariUrl)
        }
    }
}

extension MainView {
    func filterActions(confirm: Bool, finished: Bool)->Void{
        if (!confirm && finished) {
            typeFilter = previousTypeFilter
            genderFilter = previousGenderFilter
        } else if (confirm && finished){            
            items = []
            do {
                try ClothingItem.loadItems(gender: genderFilter, type: typeFilter) { clothingItems in
                    preLoadAmount = clothingItems.count
                    for item in clothingItems {
                        if (!items.contains(item)) {
                            items.append(item)
                        }
=======
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
                                pageState = previousPageState
                            } else if newState == .editing {
                                pageState = previousPageState
                                swipeClothingManager.reset()
                                
                                //confirm
                                DispatchQueue.global(qos: .userInitiated).async {
                                    do {
                                        try swipeClothingManager.loadItems()
                                    } catch {
                                        //TODO: Display error
                                    }
                                }
                            } else {
                                pageState = newState
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
>>>>>>> rebuild
                    }
                    Spacer()
                }
            } catch {
                exit(0)
            }
<<<<<<< HEAD
            collectionPaginator = ClothingItemPaginator(requestType: .likes, clothingType: typeFilter, gender: genderFilter)
        } else {
            previousTypeFilter = typeFilter
            previousGenderFilter = genderFilter
            typeFilter = []
=======
>>>>>>> rebuild
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
<<<<<<< HEAD
        MainView(items: .constant(ClothingItem.sampleItems), preLoadAmount: .constant(5))
        MainView(items: .constant(ClothingItem.sampleItems), preLoadAmount: .constant(5))
=======
        MainView(api: Api(), swipeClothingManager: ClothingListManager())
        MainView(api: Api(), swipeClothingManager: ClothingListManager())
>>>>>>> rebuild
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
