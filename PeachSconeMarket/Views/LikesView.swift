//
//  LikesView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct LikesView: View {
    @State var errorMessage: String = ""
    
    @Binding var items: [ClothingItem]
    @Binding var selectedItems: [Int]
    @Binding var isPresentingSafari:Bool
    @Binding var safariUrl: URL
    @Binding var editing: Bool
    @Binding var typeFilter: [String]
    @Binding var genderFilter: String
    
    var body: some View {
        ZStack{
            VStack(alignment: .center){
                ScrollView(showsIndicators: false) {
                    InlineTitleView()
                        .frame(alignment: .top)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.001)
                    Text(editing ? "Editing Likes" : "Likes")
                            .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.075, relativeTo: .title3))
                            .foregroundColor(Color("DarkText"))
                    CardCollectionView(items: $items, isPresentingSafari: $isPresentingSafari, safariUrl: $safariUrl, editing: $editing, selectedItems: $selectedItems)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.025)
                }
            }
            if items.count == 0 && errorMessage.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
                    .onAppear{
                        items = LoadItems()
                    }
            }
            if !errorMessage.isEmpty {
                Text("\(errorMessage)")
                    .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.04, relativeTo: .caption))
                    .foregroundColor(.red)
            }
        }.onDisappear{
            items = []
        }
    }
}

extension LikesView{
    func LoadItems() -> [ClothingItem] {
        do {
            return try CollectionStruct.collectionRequest(type: .likes, clothingType: typeFilter, gender: genderFilter)
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
        LikesView(items: .constant(ClothingItem.sampleItems),selectedItems: .constant([0]), isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!), editing: .constant(false), typeFilter: .constant(["top"]), genderFilter: .constant("male"))
        LikesView(items: .constant(ClothingItem.sampleItems), selectedItems: .constant([0]), isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!), editing: .constant(true), typeFilter: .constant(["top"]), genderFilter: .constant("male"))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}
