//
//  SwipeView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct SwipeView: View {
    @Binding var items: [ClothingItem]
    
    var body: some View {
            VStack{
                Spacer()
                InlineTitleView()
                    Spacer()
                ZStack{
                    ForEach(items.reversed()) { item in 
                        CardView(items: $items, item: item)
                    }
                }
                if (items.count > 0) {
                    Text("\(items[0].name)")
                        .font(CustomFontFactory.getFont(style: "Regular", size: 20))
                        .multilineTextAlignment(TextAlignment.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: 350)
                        .foregroundColor(Color("DarkText"))
                        .lineLimit(3)
                        .padding(.bottom, 15)
                }
            }
    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView(items: .constant(ClothingItem.sampleItems))
    }
}
