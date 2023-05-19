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
                    SwipeView(items: $items, typeFilter: $typeFilter, genderFilter: $genderFilter)
                } else if state == .likes {
                    LikesView(items: $collectionItems, selectedItems: $selectedItems ,isPresentingSafari: $isPresentingSafari, safariUrl: $safariUrl, editing: $editing, typeFilter: $typeFilter, genderFilter: $genderFilter)
                } else if state == .collection {
                    CollectionView()
                }
                Spacer()
                NavigationButtonView(showEdit: false, showFilter: true, state: $state, editing: $editing, selectedItems: $selectedItems, collectionItems: $collectionItems, filtering: $filtering, filterActions: filterActions)
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
            switch state {
            case .main:
                items = []
                for var i in 1...PeachSconeMarketApp.preLoadAmount {
                    ClothingItem.loadItem(gender: genderFilter, type: typeFilter) { item in
                        if (!items.contains(item)) {
                            items.append(item)
                        } else {
                            i -= 1
                        }
                    }
                }
            case .likes:
                collectionItems = []
            case .collection:
                break
            }
        } else {
            previousTypeFilter = typeFilter
            previousGenderFilter = genderFilter
            typeFilter = []
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(items: .constant(ClothingItem.sampleItems))
        MainView(items: .constant(ClothingItem.sampleItems))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}

enum pageState {
    case likes
    case main
    case collection
}
