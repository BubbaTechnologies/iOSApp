//
//  SwipeView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct SwipeView: View {
    static var clothingWithPreloadedImages = 3
    
    @ObservedObject var api:Api
    @ObservedObject var clothingManager: ClothingListManager
    @ObservedObject var store: LikeStore
    
    @Binding var pageState:PageState
    var changeFunction: (PageState)->Void
    
    @State var errorMessage: String = ""
    
    //Design Variables
    private let widthFactor: Double = 0.81
    private let heightFactor: Double = 0.10
    /**
                Determines how low the card count can get before the loading screen appears.
     */
    private let maximumLoadingCount: Int = 2
    private let maxZIndex = 12
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack{
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.028)
                    .padding(.bottom, reader.size.height * 0.01)
                VStack{
                    if (clothingManager.clothingItems.count <= (maximumLoadingCount)) {
                        VStack{
                            Spacer()
                            if !errorMessage.isEmpty{
                                Text("\(errorMessage)")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            } else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                                    .scaleEffect(3)
                            }
                            Spacer()
                        }
                    } else {
                        ZStack{
                            //Creates card for each clothing item in list
                            ForEach(Array(clothingManager.clothingItems.enumerated()), id: \.element.id) { index, item in
                                CardView(cardManager: clothingManager.clothingCardManagers[index], swipeAction: cardAction, preloadImages: index < SwipeView.clothingWithPreloadedImages)
                                .frame(height: reader.size.height * 0.75)
                                .disabled(index != 0)
                                .zIndex(Double(maxZIndex - index))
                            }
                        }.onAppear{
                            errorMessage = ""
                        }
                        if (clothingManager.clothingItems.count > 0) {
                            Text("\(clothingManager.clothingItems[0].name)")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                                .minimumScaleFactor(0.85)
                                .multilineTextAlignment(TextAlignment.center)
                                .foregroundColor(Color("DarkFontColor"))
                                .lineLimit(2)
                                .frame(width: reader.size.width * 0.9, height: reader.size.height * 0.1, alignment: .top)
                        }
                    }
                }.frame(height: reader.size.height * 0.85)
                NavigationButtonView(showFilter: true, showEdit: false, options: .constant(false), buttonAction: changeFunction)
                .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                .padding(.bottom, reader.size.height * NavigationViewDesignVariables.BOTTOM_PADDING_FACTOR)
            }.frame(width: reader.size.width, height: reader.size.height)
        }
    }
}

extension SwipeView {
    func cardAction(item: ClothingItem, imageTapRatio: Double, userLiked: Bool) {
        //Sends like/dislike
        let likeStruct: LikeStruct = LikeStruct(clothingId: item.id, imageTapRatio: imageTapRatio, likeType: userLiked ? .like : .dislike)
        
        DispatchQueue.global(qos: .background).async {
            do {
                try api.sendLike(likeStruct: likeStruct)
            } catch {
                //Adds like to likeStore
                print("\(error)")
                print("Adding like to likeStore: \(likeStruct)")
                self.store.likes.append(likeStruct)
            }
        }
        
        clothingManager.removeFirst()
        
        do {
            try clothingManager.loadNext()
        } catch Api.ApiError.httpError(let message) {
            if clothingManager.clothingItems.count < maximumLoadingCount {
                errorMessage = message
            }
        } catch {
            if clothingManager.clothingItems.count < maximumLoadingCount {
                errorMessage = "Something isn't right. Error Message: \(error)"
            }
        }
    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView(api: Api(), clothingManager: ClothingListManager(clothingItems: ClothingItem.sampleItems), store: LikeStore(), pageState: .constant(.swipe), changeFunction: {_ in return})
    }
}
