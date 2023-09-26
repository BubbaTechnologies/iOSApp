//
//  LikesView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct LikesView: View {
    @ObservedObject var clothingManager: ClothingPageManager
    @Binding var pageState: PageState
    var changeFunction: (PageState)->Void
    
    @State var errorMessage: String = ""
    @State var attemptedLoad: Bool = false
    
    @State var isPresentingSafari:Bool = false
    @State var safariUrl: URL? = nil
    
<<<<<<< HEAD
    @ObservedObject var paginator: ClothingItemPaginator
    @Binding var selectedItems: [Int]
    @Binding var isPresentingSafari:Bool
    @Binding var safariUrl: URL
    @Binding var editing: Bool
    
    @State private var contentHeight: CGFloat = 0.0
    private let firstPageMultiplier: CGFloat = 1.86522
    private let nextPageMultiplier: CGFloat = 2.614383
    @State private var loading: Bool = true
    @State private var more: Bool = true
    
    @Namespace var collectionID
    
    var body: some View {
        ZStack{
            ScrollViewReader{ proxy in
                ScrollView(showsIndicators: false) {
                    GeometryReader{ geometry in
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: loading ? CGPoint(x:0, y:0) : geometry.frame(in: .named("scrollView")).origin)
                    }.frame(width: 0, height: 0)
                    VStack{
                        InlineTitleView()
                            .frame(alignment: .top)
                            .padding(.bottom, UIScreen.main.bounds.height * 0.001)
                        Text(editing ? "Editing Likes" : "Likes")
                            .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.075, relativeTo: .title3))
                            .foregroundColor(Color("DarkText"))
                        CardCollectionView(items: $paginator.clothingItems, isPresentingSafari: $isPresentingSafari, safariUrl: $safariUrl, editing: $editing, selectedItems: $selectedItems)
                        EmptyView()
                            .id(collectionID)
                            .padding(.horizontal, UIScreen.main.bounds.width * 0.025)
                        if loading && more {
                            ProgressView()
                                .frame(height: UIScreen.main.bounds.height * 0.05)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                                .scaleEffect(1.25)
                        }
                    }
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear{
                            contentHeight = geometry.size.height
                        }
                })
                .coordinateSpace(name: "scrollView")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    if (!loading) {
                        loading = true
                        let pageNumber: CGFloat =  CGFloat(paginator.currentPage - 1)
                        let perPage: CGFloat = contentHeight * (pageNumber * nextPageMultiplier)
                        let initial: CGFloat = contentHeight * firstPageMultiplier
                        if (abs(value.y) >=  perPage + initial) {
                            do {
                                more = try paginator.loadNextPage()
                                proxy.scrollTo(collectionID)
                            } catch HttpError.runtimeError(let message) {
                                errorMessage = "\(message)"
                                paginator.clothingItems.removeAll()
                            } catch {
                                errorMessage = "\(error)"
                            }
                        }
                        loading = false
                    }
                }
            }
            if paginator.clothingItems.count == 0 && errorMessage.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.01)
                    .onAppear{
                        do {
                            _ = try paginator.loadNextPage()
                            loading = false
                        } catch HttpError.runtimeError(let message) {
                            errorMessage = "\(message)"
                        } catch {
                            errorMessage = "\(error)"
=======
    @State var selectedClothingItems: [Int] = []

    @State var editing: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.025)
                    .padding(.bottom, reader.size.height * 0.01)
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                            Text(editing ? "Editing Likes" : "Likes")
                                .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.075, relativeTo: .title3))
                                .foregroundColor(Color("DarkText"))
                            if errorMessage.isEmpty && attemptedLoad {
                                CardCollectionView(items: $clothingManager.clothingItems,  safariUrl: $safariUrl, editing: $editing, selectedItems: $selectedClothingItems)
                                    .frame(height: reader.size.height * (Double(
                                        (clothingManager.clothingItems.count % 2 == 0 ? clothingManager.clothingItems.count : clothingManager.clothingItems.count + 1)) / 5.0))
                                if !clothingManager.allClothingItemsLoaded {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                                        .scaleEffect(2)
                                        .padding(.top,  reader.size.height * 0.05)
                                        .onAppear{
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                clothingManager.loadNext() { result in
                                                    switch result {
                                                    case .success(_):
                                                        break
                                                    case .failure(let error):
                                                        if case Api.ApiError.httpError(let message) = error {
                                                            errorMessage = message
                                                        } else {
                                                            errorMessage = "Something isn't right. Error Message: \(error)"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                }
                                Spacer(minLength: reader.size.height * 0.025)
                            } else if !attemptedLoad {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                                    .scaleEffect(3)
                                    .frame(height: reader.size.height * 0.75)
                            } else {
                                Spacer(minLength: reader.size.height * 0.2)
                                Text("\(errorMessage)")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                    }
                }.frame(height: reader.size.height * 0.85)
                NavigationButtonView(showFilter: true, showEdit: true, options: $editing, buttonAction: navigationFunction)
                    .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                    .padding(.bottom, reader.size.height * 0.005)
            }
            .frame(width: reader.size.width, height: reader.size.height)
        }
        .sheet(isPresented: Binding<Bool> (
            get: { self.safariUrl != nil },
            set: {isPresented in
                if !isPresented {
                    self.safariUrl = nil
                }
            }
        )) {
            SafariView(url: Binding($safariUrl)!)
        }
        .onDisappear{
            clothingManager.reset()
        }
        .onAppear{
            DispatchQueue.global(qos: .userInitiated).async{
                clothingManager.loadNext() { result in
                    switch result {
                    case .success(let empty):
                        if empty {
                            if clothingManager.clothingItems.count == 0 {
                                errorMessage = "Start liking clothing!"
                            }
                        }
                        attemptedLoad = true
                    case .failure(let error):
                        if case Api.ApiError.httpError(let message) = error {
                            errorMessage = message
                        } else {
                            errorMessage = "Something isn't right. Error Message: \(error)"
>>>>>>> rebuild
                        }
                    }
                }
            }
<<<<<<< HEAD
            if !errorMessage.isEmpty {
                Text("\(errorMessage)")
                    .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.04, relativeTo: .caption))
                    .foregroundColor(.red)
            }
        }.onDisappear{
            paginator.reset()
=======
>>>>>>> rebuild
        }
    }
}

<<<<<<< HEAD
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: ()->CGPoint){}
=======
extension LikesView {
    func navigationFunction(pageState: PageState) {
        if editing {
            //If editing and confirmed
            if pageState == .editing {
                clothingManager.clothingItems = clothingManager.clothingItems.filter{
                    !selectedClothingItems.contains($0.id)
                }
                
                for id in selectedClothingItems {
                    let likeStruct:LikeStruct = LikeStruct(clothingId: id, imageTapRatio: 0, likeType: .removeLike)
                    do {
                        try clothingManager.api.sendLike(likeStruct: likeStruct)
                    } catch {
                        //TODO:Persist data and send later
                    }
                }
            }
            
            if pageState == .editing || pageState == .filtering {
                editing = false
                selectedClothingItems = []
                return
            }
        }
        
        
        if pageState == .editing {
            editing = true
            return
        }
        
        changeFunction(pageState)
    }
>>>>>>> rebuild
}


struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
<<<<<<< HEAD
        LikesView(paginator: ClothingItemPaginator(requestType: .likes, clothingItems: ClothingItem.sampleItems),selectedItems: .constant([0]), isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!), editing: .constant(true))
        LikesView(paginator: ClothingItemPaginator(requestType: .likes, clothingItems: ClothingItem.sampleItems), selectedItems: .constant([0]), isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!), editing: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
=======
        LikesView(clothingManager: ClothingPageManager(clothingItems: ClothingItem.sampleItems), pageState: .constant(.likes), changeFunction: {_ in return})
>>>>>>> rebuild
    }
}



