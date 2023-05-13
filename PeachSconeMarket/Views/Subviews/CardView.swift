//
//  CardView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct CardView: View {
    @State private var offset = CGSize.zero
    private let widthFactor: Double = 0.38
    private let heightToWidthRatio: Double = 1.75
    @State private var currentImageIndex: Int = 0
    
    @Binding public var items: [ClothingItem]
    public var item: ClothingItem
    
    var body: some View {
        ZStack{
            AsyncImage(url: URL(string: item.imageURL[currentImageIndex])) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
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
                                            .frame(width: UIScreen.main.bounds.height * 0.009, alignment: .center)
                                    } else {
                                        Circle()
                                            .fill(.white)
                                            .opacity(0.5)
                                            .id("Circle" + String(index))
                                            .frame(width: UIScreen.main.bounds.height * 0.009, alignment: .center)
                                    }
                                    Circle()
                                        .strokeBorder(Color("DarkText"), lineWidth:0.5)
                                        .frame(width: UIScreen.main.bounds.height * 0.009, alignment: .center)
                                }.padding(.horizontal, -3)
                            }
                        }.offset(y:UIScreen.main.bounds.height * (widthFactor - 0.07))
                    }
                case .failure:
                    //TODO: Handle failure to load
                    Text("Failure to Load")
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.black)
                                .frame(width: UIScreen.main.bounds.height * widthFactor, height: UIScreen.main.bounds.height * (widthFactor * heightToWidthRatio), alignment: .center)
                        )
                        .foregroundColor(Color("DarkText"))
                @unknown default:
                    EmptyView()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color("DarkText"))
                    .frame(width: UIScreen.main.bounds.height * widthFactor, height: UIScreen.main.bounds.height * (widthFactor * heightToWidthRatio), alignment: .center)
            )
            .padding(.horizontal, 20)
            .frame(width: UIScreen.main.bounds.height * widthFactor, height: UIScreen.main.bounds.height * (widthFactor * heightToWidthRatio), alignment: .center)
            .background(Color("LightText"))
            .cornerRadius(50)
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
                currentImageIndex = (currentImageIndex + 1) % item.imageURL.count
            }
        }
    }
}

extension CardView{
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            offset = CGSize(width: -500, height: 0)
            Task{
                await removeCard(rating: 0)
            }
        case 150...500:
            offset = CGSize(width: 500, height: 0)
            Task {
                await removeCard(rating: 5)
            }
        default:
            offset = .zero
        }
    }
    
    func removeCard(rating:Int) async {
        items.removeFirst()
        
        //Create LikeStruct
        let likeStruct:LikeStruct = LikeStruct(clothingId: String(item.id), rating: String(rating))
        do {
           try LikeStruct.createLikeRequest(likeStruct: likeStruct)
        } catch  {
            print("\(error)")
        }
        
        //Loads new items
        for var i in 0...(PeachSconeMarketApp.preLoadAmount - items.count) {
            ClothingItem.loadItem() { item in
                if (!items.contains(item)) {
                    items.append(item)
                } else {
                    i -= 1
                }
            }
        }
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(items: .constant(ClothingItem.sampleItems), item: ClothingItem.sampleItems[0])
    }
}

