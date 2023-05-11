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
    
    var body: some View {
        ZStack{
            VStack(alignment: .center){
                LazyVGrid(columns: columns) {
                    ForEach(items.reversed()){ item in
                        MiniCardView(item: item)
                    }
                }
            }
        }
    }
}

struct CardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardCollectionView(items: .constant(ClothingItem.sampleItems))
    }
}
