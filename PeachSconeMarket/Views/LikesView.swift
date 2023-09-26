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
                        }
                    }
                }
            }
        }
    }
}

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
}


struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView(clothingManager: ClothingPageManager(clothingItems: ClothingItem.sampleItems), pageState: .constant(.likes), changeFunction: {_ in return})
    }
}



