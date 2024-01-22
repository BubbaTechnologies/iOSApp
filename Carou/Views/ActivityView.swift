//
//  ActivityView.swift
//  Carou
//
//  Created by Matt Groholski on 1/16/24.
//

import SwiftUI

struct ActivityView: View {
    
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center){
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.024)
                    .padding(.bottom, reader.size.height * 0.01)
                VStack{
                    
                }.frame(height: reader.size.height * 0.85, alignment: .center)
                NavigationButtonView(auxiliary: .constant((AuxiliaryType.filtering, AuxiliaryType.adding)), buttonAction: navigationFunction)
                    .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                    .padding(.bottom, reader.size.height * NavigationViewDesignVariables.BOTTOM_PADDING_FACTOR)
            }.frame(width: reader.size.width, height: reader.size.height)
        }
    }
}

extension ActivityView {
    func navigationFunction(pageState: PageState) {
        //TODO
    }
}

#Preview {
    ActivityView()
}
