//
//  MiniCardView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct MiniCardView: View {
    public var item: ClothingItem
    private let imageWidthScale: Double = 0.15
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: item.imageURL[0])) { phase in
                switch phase {
                case .empty:
                    //TODO: Deal with empty text
                    Text("Empty")
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.height * imageWidthScale, height: UIScreen.main.bounds.height * (imageWidthScale/0.5714285714), alignment: .center)
                        .cornerRadius(20)
                        .clipped()
                        .overlay(
                            //Width to cornerRadius ratio is 125x
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.black)
                        )
                case .failure:
                    //TODO: Handle failure to load
                    Text("Failure")
                @unknown default:
                    //TODO: Handle default case
                    EmptyView()
                }
                Text("\(item.name)")
                    .font(CustomFontFactory.getFont(style: "Regular", size: 18))
                    .multilineTextAlignment(TextAlignment.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: UIScreen.main.bounds.height * (imageWidthScale + 0.01))
                    .foregroundColor(Color("DarkText"))
                    .lineLimit(5)
            }
        }
    }
}

struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(item:ClothingItem.sampleItems[0])
    }
}
