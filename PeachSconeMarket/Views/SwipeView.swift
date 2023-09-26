//
//  SwipeView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct SwipeView: View {
    static var clothingWithPreloadedImages = 4
    
    @ObservedObject var api:Api
    @ObservedObject var clothingManager: ClothingListManager
    @Binding var pageState:PageState
    var changeFunction: (PageState)->Void
    
    @State var errorMessage: String = ""
    
    //Design Variables
    private let widthFactor: Double = 0.81
    private let heightFactor: Double = 0.10
    private let maximumLoadingCount: Int = 5
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack{
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.025)
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
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                                    .scaleEffect(3)
                            }
                            Spacer()
                        }
                    } else {
                        ZStack{
                            //Creates card for each clothing item in list
                            ForEach(Array(clothingManager.clothingItems.reversed().enumerated()), id: \.element.id) { index, item in
                                CardView(cardManager: CardManager(item: item), swipeAction: cardAction, preloadImages:
                                            (clothingManager.clothingItems.count - index) < SwipeView.clothingWithPreloadedImages)
                                .frame(height: reader.size.height * 0.75)
                            }
                        }.onAppear{
                            errorMessage = ""
                        }
                        if (clothingManager.clothingItems.count > 0) {
                            Text("\(clothingManager.clothingItems[0].name)")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                                .minimumScaleFactor(0.85)
                                .multilineTextAlignment(TextAlignment.center)
                                .foregroundColor(Color("DarkText"))
                                .lineLimit(2)
                                .frame(width: reader.size.width * 0.9, height: reader.size.height * 0.1, alignment: .top)
                        }
                    }
                }.frame(height: reader.size.height * 0.85)
                NavigationButtonView(showFilter: true, showEdit: false, options: .constant(false), buttonAction: changeFunction)
                .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                .padding(.bottom, reader.size.height * 0.005)
            }.frame(width: reader.size.width, height: reader.size.height)
        }
    }
}

extension SwipeView {
    func cardAction(item: ClothingItem, imageTapRatio: Double, userLiked: Bool) {
        //Sends like/dislike
        let likeStruct: LikeStruct = LikeStruct(clothingId: item.id, imageTapRatio: imageTapRatio, likeType: userLiked ? .like : .dislike)
        do {
            try api.sendLike(likeStruct: likeStruct)
        } catch {
            //TODO: Persist like data if failure
            //Send like data at load
        }
        
        clothingManager.clothingItems.removeFirst()
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
        SwipeView(api: Api(), clothingManager: ClothingListManager(clothingItems: ClothingItem.sampleItems), pageState: .constant(.swipe), changeFunction: {_ in return})
    }
}
