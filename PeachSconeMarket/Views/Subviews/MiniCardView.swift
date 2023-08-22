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
    @Binding var editing: Bool
    @State var selected: Bool = false
    @Binding var selectedItems: [Int]
    
    var body: some View {
        ZStack {
            VStack{
                AsyncImage(url: URL(string: item.imageURL[0])) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                            .scaleEffect(3)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .clipped()
                            .onTapGesture {
                                if editing {
                                    selected.toggle()
                                    if selected {
                                        selectedItems.append(item.id)
                                    } else {
                                        selectedItems = selectedItems.filter{
                                            $0 != item.id
                                        }
                                    }
                                } else {
                                    if let url = URL(string: item.productURL) {
                                        //Create LikeStruct
//                                        let likeStruct:LikeStruct = LikeStruct(clothingId: item.id, imageTapRatio: 0)
//                                        do {
//                                            try LikeStruct.createLikeRequest(likeStruct: likeStruct, likeType: .pageClick)
//                                        } catch  {
//                                            print("\(error)")
//                                        }
                                        safariUrl = url
                                        isPresentingSafari = true
                                    }
                                }
                            }
                    case .failure:
                        Text("Failure to Load")
                    @unknown default:
                        //TODO: Handle default case
                        EmptyView()
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("DarkText"))
                        .frame(width: UIScreen.main.bounds.width * widthFactor, height: UIScreen.main.bounds.height * heightFactor, alignment: .center)
                    
                )
                .frame(width: UIScreen.main.bounds.width * widthFactor, height: UIScreen.main.bounds.height * heightFactor, alignment: .center)
                .background(Color("LightText"))
                .cornerRadius(15)
                VStack(alignment: .center){
                    Text("\(item.name)")
                        .lineLimit(4)
                        .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * 0.05, relativeTo: .caption))
                        .multilineTextAlignment(TextAlignment.leading)
                        .foregroundColor(Color("DarkText"))
                    Spacer()
                }.frame(width: UIScreen.main.bounds.width * (widthFactor + 0.01), height: UIScreen.main.bounds.height * heightFactor * 0.4)
            }
            if (editing) {
                SelectedView(selected: $selected)
                    .offset(x:UIScreen.main.bounds.width * (widthFactor - 0.51), y: UIScreen.main.bounds.height * ((heightFactor * 0.4) - 0.325))
            }
        }
    }
}

struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(item:ClothingItem.sampleItems[0], isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!), editing: .constant(true), selectedItems: .constant([]))
    }
}
