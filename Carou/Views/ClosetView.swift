//
//  CollectionView.swift
//  Carou
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct ClosetView: View {
    @ObservedObject var clothingManager: ClothingPageManager
    @ObservedObject var likeStore: LikeStore
    @Binding var pageState: PageState
    var changeFunction: (PageState)->Void
    
    @State var selectedClothingItems: [Int] = []

    @State var editing: Bool = false
    @State var loading: Bool = false
    
    @State var auxNavButtons = (AuxiliaryType.filtering, AuxiliaryType.editing)
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.028)
                    .padding(.bottom, reader.size.height * 0.01)
                CardScrollView(name: "Closet", clothingManager: clothingManager, likeStore: likeStore, selectedClothingItems: $selectedClothingItems, editing: $editing)
                    .frame(height: reader.size.height * 0.85, alignment: .center)
                NavigationButtonView(auxiliary: $auxNavButtons, buttonAction: changeFunction)
                    .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                    .padding(.bottom, reader.size.height * NavigationViewDesignVariables.BOTTOM_PADDING_FACTOR)
            }
            .frame(width: reader.size.width, height: reader.size.height)
        }
    }
}

extension ClosetView {
    func navigationFunction(pageState: PageState) {
        //Confirming an edit
        if pageState == .auxiliary(.confirm) {
            clothingManager.clothingItems = clothingManager.clothingItems.filter{
                !selectedClothingItems.contains($0.id)
            }
            
            for id in selectedClothingItems {
                let likeStruct:LikeStruct = LikeStruct(clothingId: id, imageTaps: 0, likeType: .removeLike)
                DispatchQueue.global(qos: .background).async{
                    do {
                        try clothingManager.api.sendLike(likeStruct: likeStruct)
                    } catch {
                        self.likeStore.likes.append(likeStruct)
                    }
                }
            }
        }
        
        if pageState == .auxiliary(.confirm) ||  pageState == .auxiliary(.cancel) {
            editing = false
            auxNavButtons = (AuxiliaryType.filtering, AuxiliaryType.editing)
            selectedClothingItems = []
            return
        }
        
        
        if pageState == .auxiliary(.editing) {
            editing = true
            auxNavButtons = (AuxiliaryType.cancel, AuxiliaryType.confirm)
            return
        }
        
        changeFunction(pageState)
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView(clothingManager: ClothingPageManager(clothingItems: ClothingItem.sampleItems), likeStore: LikeStore(), pageState: .constant(.closet), changeFunction: {_ in return})
    }
}
