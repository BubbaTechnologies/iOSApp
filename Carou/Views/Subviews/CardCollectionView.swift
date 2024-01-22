//
//  CollectionView.swift
//  Carou
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct CardCollectionView: View {
    @Binding var items: [ClothingItem]
    var tapAction: (Int)->Void
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var suboverlay: (Alignment, (Int) -> AnyView) = (.leading, {_ in AnyView(EmptyView())})
    
    init(items: Binding<[ClothingItem]>, tapAction: @escaping (Int)->Void) {
        self._items = items
        self.tapAction = tapAction
    }
    
    init(items: Binding<[ClothingItem]>, tapAction: @escaping (Int)->Void, suboverlay: (Alignment, (Int)->AnyView)) {
        self._items = items
        self.tapAction = tapAction
        self.suboverlay = suboverlay
    }
    
    var body: some View {
        GeometryReader{ reader in
            LazyVStack(alignment: .center, spacing: 0){
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(items.indices, id: \.self){ i in
                        MiniCardView(item: items[i]) {
                            tapAction(i)
                        }
                        .overlay(alignment: suboverlay.0) {
                            suboverlay.1(i)
                        }
                        .frame(width: reader.size.width * 0.4, height: reader.size.height * (2.0/Double(
                            (items.count % 2 == 0 ? items.count : items.count + 1)
                        )))
                    }
                }
            }
        }
    }
    
    
    
}

extension CardCollectionView {
    func suboverlay<V>(alignment: Alignment, @ViewBuilder content: @escaping (Int) -> V) -> some View where V : View {
        return CardCollectionView(items: self.$items, tapAction: self.tapAction, suboverlay: (alignment, {i in AnyView(content(i))}))
    }
}

struct CardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardCollectionView(items: .constant(ClothingItem.sampleItems),tapAction: {_ in return})
    }
}
