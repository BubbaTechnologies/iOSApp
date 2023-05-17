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
    @Binding var isPresentingSafari:Bool
    @Binding var safariUrl: URL
    
    var body: some View {
        ZStack{
            VStack(alignment: .center){
                ScrollView(showsIndicators: false) {
                    InlineTitleView()
                        .frame(alignment: .top)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.001)
                    Text("Likes")
                        .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.08, relativeTo: .title2))
                        .foregroundColor(Color("DarkText"))
                    CardCollectionView(items: $items, isPresentingSafari: $isPresentingSafari, safariUrl: $safariUrl)
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
                    .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.04, relativeTo: .caption))
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
        LikesView(items: ClothingItem.sampleItems, isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!))
        LikesView(items: ClothingItem.sampleItems, isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}
