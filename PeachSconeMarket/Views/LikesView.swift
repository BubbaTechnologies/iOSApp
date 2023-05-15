//
//  LikesView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct LikesView: View {
    @State var items: [ClothingItem] = []
    @State var errorMessage: String = ""
    
    var body: some View {
        ZStack{
            VStack(alignment: .center){
                ScrollView(showsIndicators: false) {
                    InlineTitleView()
                        .frame(alignment: .top)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.001)
                    Text("Likes")
                        .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.08))
                        .foregroundColor(Color("DarkText"))
                    CardCollectionView(items: $items)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.025)
                }
            }
            if items.count == 0 && errorMessage.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
            }
            if !errorMessage.isEmpty {
                Text("\(errorMessage)")
                    .font(CustomFontFactory.getFont(style: "Bold", size: 15))
                    .foregroundColor(.red)
            }
        }.onAppear{
            if items.isEmpty {
                items = LoadItems()
            }
        }.onDisappear{
            items = []
        }
    }
}

extension LikesView{
    func LoadItems() -> [ClothingItem] {
        do {
            return try CollectionStruct.collectionRequest(type: "likes")
        } catch HttpError.runtimeError(let message) {
            errorMessage = "\(message)"
        } catch {
            errorMessage = "\(error)"
        }
        return []
    }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView(items: ClothingItem.sampleItems)
        LikesView(items: ClothingItem.sampleItems)
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}
