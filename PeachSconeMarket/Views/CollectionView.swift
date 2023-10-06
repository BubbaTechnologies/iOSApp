//
//  CollectionView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct CollectionView: View {
    var changeFunction: (PageState)->Void
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.025)
                    .padding(.bottom, reader.size.height * 0.01)
                Text("Why does the chicken cross the road?")
                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                    .frame(height: reader.size.height * 0.85)
                    .foregroundColor(Color("DarkFontColor"))
                NavigationButtonView(showFilter: false, showEdit: false, options: .constant(false), buttonAction: changeFunction)
                    .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                    .padding(.bottom, reader.size.height * 0.005)
            }
            .frame(width: reader.size.width, height: reader.size.height)
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(changeFunction: {_ in return})
    }
}
