//
//  MiniCardView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct MiniCardView: View {
    public var item: ClothingItem
    private let widthFactor: Double = 0.35
    private let heightFactor: Double = 0.3
    @Binding var isPresentingSafari:Bool
    @Binding var safariUrl: URL
    
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
                        .frame(width: UIScreen.main.bounds.width * widthFactor, height: UIScreen.main.bounds.height * heightFactor, alignment: .center)
                        .background(Color("LightText"))
                        .cornerRadius(15)
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * widthFactor, height: UIScreen.main.bounds.height * heightFactor, alignment: .center)
                        .cornerRadius(15)
                        .clipped()
                        .overlay(
                            //Width to cornerRadius ratio is 125x
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("DarkText"))
                        )
                        .onTapGesture {
                            if let url = URL(string: item.productURL) {
                                //UIApplication.shared.open(url)
                                safariUrl = url
                                isPresentingSafari = true
                            }
                        }
                case .failure:
                    Text("Failure to Load")
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.black)
                                .frame(width: UIScreen.main.bounds.width * widthFactor, height: UIScreen.main.bounds.height * heightFactor, alignment: .center)
                        )
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * widthFactor, height: UIScreen.main.bounds.height * heightFactor, alignment: .center)
                        .background(Color("LightText"))
                        .cornerRadius(15)
                @unknown default:
                    //TODO: Handle default case
                    EmptyView()
                }
                VStack(alignment: .center){
                    Text("\(item.name)")
                        .lineLimit(4)
                        .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * 0.05, relativeTo: .caption))
                        .multilineTextAlignment(TextAlignment.leading)
                        .foregroundColor(Color("DarkText"))
                    Spacer()
                }.frame(width: UIScreen.main.bounds.width * (widthFactor + 0.01), height: UIScreen.main.bounds.height * heightFactor * 0.4)
            }
        }
    }
}

struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(item:ClothingItem.sampleItems[0], isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!))
    }
}
