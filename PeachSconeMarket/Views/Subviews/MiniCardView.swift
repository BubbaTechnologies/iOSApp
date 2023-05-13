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
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("DarkText"))
                        )
                        .frame(width: UIScreen.main.bounds.height * imageWidthScale, height: UIScreen.main.bounds.height * (imageWidthScale/0.5714285714), alignment: .center)
                        .background(Color("LightText"))
                        .cornerRadius(15)
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.height * imageWidthScale, height: UIScreen.main.bounds.height * (imageWidthScale/0.5714285714), alignment: .center)
                        .cornerRadius(15)
                        .clipped()
                        .overlay(
                            //Width to cornerRadius ratio is 125x
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("DarkText"))
                        )
                        .onTapGesture {
                            if let url = URL(string: item.productURL) {
                                UIApplication.shared.open(url)
                            }
                        }
                case .failure:
                    Text("Failure to Load")
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.black)
                                .frame(width: UIScreen.main.bounds.height * imageWidthScale, height: UIScreen.main.bounds.height * (imageWidthScale/0.5714285714), alignment: .center)
                        )
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.height * imageWidthScale, height: UIScreen.main.bounds.height * (imageWidthScale/0.5714285714), alignment: .center)
                        .background(Color("LightText"))
                        .cornerRadius(15)
                @unknown default:
                    //TODO: Handle default case
                    EmptyView()
                }
                VStack(alignment: .center){
                    Text("\(item.name)")
                        .font(CustomFontFactory.getFont(style: "Regular", size: 18))
                        .multilineTextAlignment(TextAlignment.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color("DarkText"))
                        .lineLimit(4)
                    Spacer()
                }.frame(width: UIScreen.main.bounds.height * (imageWidthScale + 0.01), height: UIScreen.main.bounds.height * (imageWidthScale/0.5714285714) * 0.4)
            }
        }
    }
}

struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(item:ClothingItem.sampleItems[0])
    }
}
