//
//  LikesView.swift
//  Carou
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct LikesView: View {
    @ObservedObject var clothingManager: ClothingPageManager
    @ObservedObject var likeStore: LikeStore
    @Binding var pageState: PageState
    var changeFunction: (PageState)->Void
    
    @State var selectedClothingItems: [Int] = []

    @State var editing: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center) {
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.024)
                    .padding(.bottom, reader.size.height * 0.01)
                CardScrollView(name: "Likes", clothingManager: clothingManager, likeStore: likeStore, selectedClothingItems: $selectedClothingItems, editing: $editing)
                    .frame(height: reader.size.height * 0.85, alignment: .center)
                NavigationButtonView(showFilter: true, showEdit: true, options: $editing, buttonAction: navigationFunction)
                    .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                    .padding(.bottom, reader.size.height * NavigationViewDesignVariables.BOTTOM_PADDING_FACTOR)
            }
            .frame(width: reader.size.width, height: reader.size.height)
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
        
        if pageState != .likes {
            clothingManager.reset()
        }
        
        changeFunction(pageState)
    }
}


struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView(clothingManager: ClothingPageManager(clothingItems: ClothingItem.sampleItems), likeStore: LikeStore(), pageState: .constant(.likes), changeFunction: {_ in return})
    }
}



