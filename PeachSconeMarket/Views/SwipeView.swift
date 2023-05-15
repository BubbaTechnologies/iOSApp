//
//  SwipeView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct SwipeView: View {
    @Binding var items: [ClothingItem]
    private let widthFactor: Double = 0.75
    private let heightFactor: Double = 0.10
    
    var body: some View {
            VStack{
                Spacer()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.0025)
                InlineTitleView()
                Spacer()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.023)
                ZStack{
                    ForEach(items.reversed()) { item in 
                        CardView(items: $items, item: item)
                    }
                }
                if (items.count > 0) {
                    Text("\(items[0].name)")
                        .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * 0.06))
                        .minimumScaleFactor(0.85)
                        .multilineTextAlignment(TextAlignment.center)
                        .foregroundColor(Color("DarkText"))
                        .lineLimit(2)
                        .padding(.bottom, 15)
                        .frame(width: UIScreen.main.bounds.width * (widthFactor + 0.06), height: UIScreen.main.bounds.height * heightFactor, alignment: .top)
                }
            }
    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView(items: .constant(ClothingItem.sampleItems))
    }
}
