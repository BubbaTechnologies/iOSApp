//
//  CardView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct CardView: View {
    @State private var offset = CGSize.zero
    static let widthFactor: Double = 0.9
    static let heightFactor: Double = 0.65
    private let circleFactor: Double = 0.02
    @State private var imageTapCount: Int = 0
    @State private var currentImageIndex: Int = 0
    
    @ObservedObject var cardManager: CardManager
    //Paramters represent item swiped, imageTapRatio, and userLiked
    public var swipeAction: (ClothingItem, Double, Bool)->Void
    public var preloadImages: Bool
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if preloadImages {
                    //Creates cards with
                    ForEach(Array(cardManager.getItem().imageURL.enumerated()), id:\.offset) { index, image in
                        CardImageView(imageUrl: image)
                            .zIndex(Double(cardManager.cardValues[index].zIndex))
                    }
                } else {
                    CardImageView(imageUrl: cardManager.getItem().imageURL[currentImageIndex])
                }
            }
            .overlay{
                HStack{
                    ForEach(0..<cardManager.getItem().imageURL.count, id:\.self) {index in
                        ZStack{
                            if (index == self.currentImageIndex) {
                                Circle()
                                    .fill(Color("DarkFontColor"))
                                    .background(Circle().fill(Color("DarkFontColor")))
                            } else {
                                Circle()
                                    .fill(Color("LightFontColor"))
                                    .opacity(0.5)
                            }
                        }
                        .frame(width: reader.size.width * circleFactor, alignment: .center)
                        .id("Circle" + String(index))
                        .padding(.horizontal, -3)
                    }
                }.offset(y: reader.size.height * 0.48)
            }
            .offset(x: offset.width)
            .rotationEffect(.degrees(Double(offset.width / 50)))
            .gesture(
                DragGesture()
                    .onChanged{ gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        withAnimation {
                            swipeCard(width: offset.width)
                        }
                    }
            )
            .onTapGesture{                
                if preloadImages {
                    //Gets current preload card index
                    let preloadAmount = cardManager.getClothingCardPreloadAmount()
                    let currentCardIndex = imageTapCount % preloadAmount
                    
                    cardManager.incrementValues(currentCardIndex: currentCardIndex)
                }
                
                currentImageIndex = (currentImageIndex + 1) % cardManager.getItem().imageURL.count
                imageTapCount += 1
            }
        }
    }
}

extension CardView {
    func swipeCard(width: CGFloat) {
            switch width {
            case -500...(-150):
                offset = CGSize(width: -500, height: 0)
                swipeAction(cardManager.getItem(), Double(imageTapCount) / Double(cardManager.getItem().imageURL.count), false)
            case 150...500:
                offset = CGSize(width: 500, height: 0)
                swipeAction(cardManager.getItem(), Double(imageTapCount) / Double(cardManager.getItem().imageURL.count), true)
            default:
                offset = .zero
            }
        }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardManager: CardManager(item: ClothingItem.sampleItems[0]), swipeAction: {_,_,_ in return}, preloadImages: true)
    }
}
