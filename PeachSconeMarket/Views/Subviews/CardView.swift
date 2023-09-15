//
//  CardView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct CardView: View {
    @State private var offset = CGSize.zero
    private let widthFactor: Double = 0.9
    private let heightFactor: Double = 0.65
    private let circleFactor: Double = 0.02
    @State private var imageTapCount: Int = 0
    @State private var currentImageIndex: Int = 0
    
    //Paramters represent item swiped, imageTapRatio, and userLiked
    @ObservedObject var cardController: CardController
    public var swipeAction: (ClothingItem, Double, Bool)->Void
    
    var body: some View {
        GeometryReader {reader in
            ZStack {
                ForEach(0..<cardController.getClothingCardPreloadAmount(), id:\.self) { index in
                    ZStack{
                        AsyncImage(url: URL(string: cardController.getItem().imageURL[cardController.cardValues[index].imageIndex])) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                                    .scaleEffect(3)
                            case .success(let image):
                                ZStack{
                                    image.resizable()
                                        .scaledToFill()
                                        .clipped()
                                }
                            case .failure:
                                Text("This is taking longer than normal...")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .caption))
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(width: reader.size.width * widthFactor, height: reader.size.height, alignment: .center)
                        .background(Color("LightText"))
                        .cornerRadius(heightFactor * 30.5)
                    }
                    .zIndex(Double(cardController.cardValues[index].zIndex))
                }
            }
            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
            .overlay{
                HStack{
                    ForEach(0..<cardController.getItem().imageURL.count, id:\.self) {index in
                        ZStack{
                            if (index == self.currentImageIndex) {
                                Circle()
                                    .background(Circle().fill(Color("DarkText")))
                            } else {
                                Circle()
                                    .fill(Color("LightText"))
                                    .opacity(0.5)
                            }
                        }
                        .frame(width: reader.size.width * circleFactor, alignment: .center)
                        .id("Circle" + String(index))
                        .padding(.horizontal, -3)
                    }
                }.offset(y:reader.size.height * 0.48)
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
                //Updates cardValues
                let currentCardIndex = currentImageIndex % cardController.getClothingCardPreloadAmount()
                for i in 0..<cardController.getClothingCardPreloadAmount() {
                    if i == currentCardIndex {
                        cardController.cardValues[i] = ((cardController.cardValues[i].zIndex + 1) % cardController.getClothingCardPreloadAmount(), (cardController.cardValues[currentCardIndex].imageIndex + cardController.getClothingCardPreloadAmount()) % cardController.getItem().imageURL.count)
                    } else {
                        cardController.cardValues[i] = ((cardController.cardValues[i].zIndex + 1) % cardController.getClothingCardPreloadAmount(), cardController.cardValues[i].imageIndex)
                    }
                }
            
                currentImageIndex = (currentImageIndex + 1) % cardController.getItem().imageURL.count
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
                swipeAction(cardController.getItem(), Double(imageTapCount) / Double(cardController.getItem().imageURL.count), false)
            case 150...500:
                offset = CGSize(width: 500, height: 0)
                swipeAction(cardController.getItem(), Double(imageTapCount) / Double(cardController.getItem().imageURL.count), true)
            default:
                offset = .zero
            }
        }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardController: CardController(item: ClothingItem.sampleItems[0]), swipeAction: {_,_,_ in return} )
    }
}
