//
//  CardView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct CardView: View {
    @State private var offset = CGSize.zero
    private let widthFactor: Double = 0.8
    private let heightFactor: Double = 0.65
    private let circleFactor: Double = 0.02
    @State private var currentImageIndex: Int = 0
    @State private var imageTapCount: Int = 0
    
    @Binding public var items: [ClothingItem]
    public var item: ClothingItem
    @Binding public var typeFilter: [String]
    @Binding public var genderFilter: String
    
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
                    }
                case .failure:
                    Text("Failure to Load")
                        .foregroundColor(Color("DarkText"))
                @unknown default:
                    EmptyView()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: heightFactor * 38.5)
                    .stroke(Color("DarkText"))
                    .frame(width: UIScreen.main.bounds.width * widthFactor, height: UIScreen.main.bounds.height * heightFactor, alignment: .center)
            )
            .padding(.horizontal, 20)
            .frame(width: UIScreen.main.bounds.width * widthFactor, height: UIScreen.main.bounds.height * heightFactor, alignment: .center)
            .background(Color("LightText"))
            .cornerRadius(heightFactor * 38.5)
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
                imageTapCount += 1
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
                await removeCard(like: false)
            }
        case 150...500:
            offset = CGSize(width: 500, height: 0)
            Task {
                await removeCard(like: true)
            }
        default:
            offset = .zero
        }
    }
    
    func removeCard(like: Bool) async {
        items.removeFirst()
        
        //Create LikeStruct
        let likeStruct:LikeStruct = LikeStruct(clothingId: item.id, imageTapRatio: (Double(imageTapCount) / Double(item.imageURL.count)))
        do {
            try LikeStruct.createLikeRequest(likeStruct: likeStruct, likeType: like ? .like : .dislike)
        } catch  {
            print("\(error)")
        }
        
        //Loads new items
        for var i in 0...max((PeachSconeMarketApp.preLoadAmount - items.count),0) {
            ClothingItem.loadItem(gender: genderFilter, type: typeFilter) { item in
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
        CardView(items: .constant(ClothingItem.sampleItems), item: ClothingItem.sampleItems[0], typeFilter: .constant([]), genderFilter: .constant(""))
    }
}

