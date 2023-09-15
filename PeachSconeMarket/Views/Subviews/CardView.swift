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
    @State private var currentImageIndex: Int = 0
    @State private var imageTapCount: Int = 0
    
    //Paramters represent item swiped, imageTapRatio, and userLiked
    public var item: ClothingItem
    public var swipeAction: (ClothingItem, Double, Bool)->Void
    
    var body: some View {
        GeometryReader {reader in
            ZStack {
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
            }.position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}

extension CardView {
    func swipeCard(width: CGFloat) {
            switch width {
            case -500...(-150):
                offset = CGSize(width: -500, height: 0)
                swipeAction(item, Double(imageTapCount) / Double(item.imageURL.count), false)
            case 150...500:
                offset = CGSize(width: 500, height: 0)
                swipeAction(item, Double(imageTapCount) / Double(item.imageURL.count), true)
            default:
                offset = .zero
            }
        }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(item: ClothingItem.sampleItems[0], swipeAction: {_,_,_ in return} )
    }
}

