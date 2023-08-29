//
//  FilterView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/18/23.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var api: Api
    var changeFunction: (PageState)->Void
    
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.025)
                    .padding(.bottom, reader.size.height * 0.01)
                Text("Maybe next week!")
                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                    .frame(height: reader.size.height * 0.85)
                    .foregroundColor(Color("DarkText"))
                NavigationButtonView(showFilter: true, showEdit: true, options: .constant(true), buttonAction: changeFunction)
                    .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                    .padding(.bottom, reader.size.height * 0.005)
            }
            .frame(width: reader.size.width, height: reader.size.height)
        }
    }
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(api: Api(), changeFunction: {_ in return})
    }
}



