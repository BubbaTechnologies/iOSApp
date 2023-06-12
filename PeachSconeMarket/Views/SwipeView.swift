//
//  SwipeView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct SwipeView: View {
    @Binding var items: [ClothingItem]
    @Binding var typeFilter:[String]
    @Binding var genderFilter: String
    @Binding var preLoadAmount: Int
    private let widthFactor: Double = 0.81
    private let heightFactor: Double = 0.10
    
    var body: some View {
            VStack{
                Spacer()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.0025)
                InlineTitleView()
                Spacer()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.023)
                if (items.count < (preLoadAmount / 2)) {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                        .scaleEffect(3)
                    Spacer()
                } else {
                    ZStack{
                        ForEach(items.reversed()) { item in
                            CardView(items: $items, item: item, typeFilter: $typeFilter, genderFilter: $genderFilter, preLoadAmount: $preLoadAmount)
                        }
                    }
                    if (items.count > 0) {
                        Text("\(items[0].name)")
                            .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * 0.08, relativeTo: .body))
                            .minimumScaleFactor(0.85)
                            .multilineTextAlignment(TextAlignment.center)
                            .foregroundColor(Color("DarkText"))
                            .lineLimit(3)
                            .padding(.bottom, 15)
                            .frame(width: UIScreen.main.bounds.width * widthFactor, height: UIScreen.main.bounds.height * heightFactor, alignment: .top)
                    }
                }
            }
    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView(items: .constant(ClothingItem.sampleItems), typeFilter: .constant(["top"]), genderFilter: .constant("male"), preLoadAmount: .constant(5))
    }
}
