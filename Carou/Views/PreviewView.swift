//
//  PreviewView.swift
//  Carou
//
//  Created by Matt Groholski on 12/12/23.
//

import SwiftUI

struct PreviewView: View {
    @ObservedObject var swipeClothingManager: ClothingListManager
    @ObservedObject var likeStore: LikeStore
    
    @Binding var appStage: CarouApp.Stage
    
    // Sets preview count
    let PREVIEW_COUNT = 5
    // Checks current preview card count.
    @State var cardCount = 0
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            ZStack {
                Text("\(swipeClothingManager.clothingItems.count)")
                SwipeView(api: swipeClothingManager.api, clothingManager: swipeClothingManager, likeStore: likeStore, initials: "", pageState: .constant(.swipe), customCardFunction: previewCardAction){ newState in
                    appStage = .authentication
                }
                .frame(width: reader.size.width, height: reader.size.height)
            }
        }
    }
}


extension PreviewView {
    func previewCardAction(item: ClothingItem, imageTaps: Int, userLiked: Bool){
        let likeStruct: LikeStruct = LikeStruct(clothingId: item.id, imageTaps: imageTaps, likeType: userLiked ? .like : .dislike)
        self.likeStore.likes.append(likeStruct)
        
        swipeClothingManager.removeFirst()
        
        if cardCount >= PREVIEW_COUNT {
            appStage = .authentication
        } else {
            self.cardCount = cardCount + 1
        }
    }
}

#Preview {
    PreviewView(swipeClothingManager: ClothingListManager(), likeStore: LikeStore(), appStage: .constant(.preview))
}
