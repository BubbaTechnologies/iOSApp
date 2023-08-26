//
//  CollectionView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct CardCollectionView: View {
    @Binding var items: [ClothingItem]
    @Binding var safariUrl: URL?
    @Binding var editing: Bool
    @Binding var selectedItems: [Int]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader{ reader in
            LazyVStack(alignment: .center){
                LazyVGrid(columns: columns) {
                    ForEach(items){ item in
                        MiniCardView(item: item, safariUrl: $safariUrl, editing: $editing, selectedItems: $selectedItems)
                            .frame(width: reader.size.width * 0.4, height: reader.size.height * (1.75 / Double(items.count)))
                    }
                }
            }
        }
    }
}

struct CardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardCollectionView(items: .constant(ClothingItem.sampleItems), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!), editing: .constant(true), selectedItems: .constant([]))
    }
}
