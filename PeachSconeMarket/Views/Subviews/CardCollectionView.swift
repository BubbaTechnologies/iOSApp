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
            LazyVStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0){
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(items.indices, id: \.self){ i in
                        MiniCardView(item: items[i], safariUrl: $safariUrl, editing: $editing, selectedItems: $selectedItems)
                            .frame(width: reader.size.width * 0.4, height: reader.size.height * (2.0/Double(
                                (items.count % 2 == 0 ? items.count : items.count + 1)
                            )))
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
