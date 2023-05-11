//
//  CollectionView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct CollectionView: View {
    @State var items: [ClothingItem]
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center){
                ScrollView(showsIndicators: false) {
                    InlineTitleView()
                        .frame(alignment: .top)
                        .padding(.bottom, 1)
                    Text("Collection")
                        .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.08))
                        .foregroundColor(Color("DarkText"))
                    CardCollectionView(items: $items)
                }
                Spacer()
                NavigationButtonView()
                    .frame(height: UIScreen.main.bounds.height * 0.05)
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(items: ClothingItem.sampleItems)
    }
}
