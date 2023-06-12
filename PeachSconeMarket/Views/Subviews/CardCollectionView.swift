//
//  CollectionView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct CardCollectionView: View {
    @Binding var items: [ClothingItem]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var isPresentingSafari:Bool
    @Binding var safariUrl: URL
    @Binding var editing: Bool
    @Binding var selectedItems: [Int]
    
    var body: some View {
        ZStack{
            LazyVStack(alignment: .center){
                LazyVGrid(columns: columns) {
                    ForEach(items){ item in
                        MiniCardView(item: item, isPresentingSafari: $isPresentingSafari, safariUrl: $safariUrl, editing: $editing, selectedItems: $selectedItems)
                    }
                }
            }
        }
    }
}

struct CardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardCollectionView(items: .constant(ClothingItem.sampleItems), isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!), editing: .constant(true), selectedItems: .constant([]))
    }
}
