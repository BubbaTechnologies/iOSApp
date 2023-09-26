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
    
<<<<<<< HEAD
    @Binding public var items: [ClothingItem]
    public var item: ClothingItem
    @Binding public var typeFilter: [String]
    @Binding public var genderFilter: String
    @Binding public var preLoadAmount: Int
    
    var body: some View {
        ZStack{
            AsyncImage(url: URL(string: item.imageURL[currentImageIndex])) { phase in
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
                        HStack{
                            ForEach(0...item.imageURL.count-1, id:\.self) {index in
                                ZStack{
                                    if (index == currentImageIndex) {
                                        Circle()
                                            .fill(.black)
                                            .id("Circle" + String(index))
                                            .frame(width: UIScreen.main.bounds.width * circleFactor, alignment: .center)
                                    } else {
                                        Circle()
                                            .fill(.white)
                                            .opacity(0.5)
                                            .id("Circle" + String(index))
                                            .frame(width: UIScreen.main.bounds.width * circleFactor, alignment: .center)
                                    }
                                    Circle()
                                        .strokeBorder(Color("DarkText"), lineWidth:0.5)
                                        .frame(width: UIScreen.main.bounds.width * circleFactor, alignment: .center)
                                }.padding(.horizontal, -3)
                            }
                        }.offset(y:UIScreen.main.bounds.height * (heightFactor) * 0.47)
=======
    @ObservedObject var cardManager: CardManager
    //Paramters represent item swiped, imageTapRatio, and userLiked
    public var swipeAction: (ClothingItem, Double, Bool)->Void
    public var preloadImages: Bool
    
    var body: some View {
        GeometryReader {reader in
            ZStack {
                if preloadImages {
                    ForEach(0..<cardManager.getClothingCardPreloadAmount(), id:\.self) { index in
                        CardImageView(imageUrl: cardManager.getItem().imageURL[cardManager.cardValues[index].imageIndex])
                            .zIndex(Double(cardManager.cardValues[index].zIndex))
>>>>>>> rebuild
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
                                    .fill(Color("DarkText"))
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
                if preloadImages {
                    //Gets current preload card index
                    let preloadAmount = cardManager.getClothingCardPreloadAmount()
                    let currentCardIndex = imageTapCount % preloadAmount
                    
                    //Updates zIndex and imageIndex
                    for i in 0..<cardManager.getClothingCardPreloadAmount() {
                        if i == currentCardIndex {
                            //Updates currentCardIndex
                            cardManager.cardValues[i] = ((cardManager.cardValues[i].zIndex + 1) % preloadAmount, (cardManager.cardValues[currentCardIndex].imageIndex + cardManager.getClothingCardPreloadAmount()) % cardManager.getItem().imageURL.count)
                        } else {
                            //Updates other cards zIndex
                            cardManager.cardValues[i] = ((cardManager.cardValues[i].zIndex + 1) % cardManager.getClothingCardPreloadAmount(), cardManager.cardValues[i].imageIndex)
                        }
                    }
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
<<<<<<< HEAD
        
        //Loads new items
        for var i in 0...max((preLoadAmount - items.count),0) {
            ClothingItem.loadItem(gender: genderFilter, type: typeFilter) { item in
                if (!items.contains(item)) {
                    items.append(item)
                } else {
                    i -= 1
=======
}

struct CardImageView: View {
    var imageUrl: String
    var body: some View {
        GeometryReader { reader in
            AsyncImage(url: URL(string: imageUrl)) { phase in
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
                        .foregroundColor(Color("DarkText"))
                @unknown default:
                    Text("This is taking longer than normal...")
                        .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .caption))
                        .foregroundColor(Color("DarkText"))
>>>>>>> rebuild
                }
            }
            .padding(.horizontal, 20)
            .frame(width: reader.size.width * CardView.widthFactor, height: reader.size.height, alignment: .center)
            .background(Color("LightText"))
            .cornerRadius(CardView.heightFactor * 30.5)
            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
<<<<<<< HEAD
        CardView(items: .constant(ClothingItem.sampleItems), item: ClothingItem.sampleItems[0], typeFilter: .constant([]), genderFilter: .constant(""), preLoadAmount: .constant(5))
=======
        CardView(cardManager: CardManager(item: ClothingItem.sampleItems[0]), swipeAction: {_,_,_ in return}, preloadImages: true)
>>>>>>> rebuild
    }
}
