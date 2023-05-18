//
//  SelectedView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/16/23.
//

import SwiftUI

struct SelectedView: View {
    @Binding public var selected: Bool
    private let scale: Double = 0.1
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color("LightText"))
                .overlay{
                    ZStack{
                        Circle()
                            .strokeBorder(Color("DarkText"), lineWidth: UIScreen.main.bounds.width * 0.001)
                        if (selected) {
                            Image(systemName:"checkmark")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(Color("DarkText"))
                                .frame(width:abs(UIScreen.main.bounds.width * (scale - 0.05)), height: UIScreen.main.bounds.height * (scale - 0.1))
                        }
                    }
                }
        }
        .frame(width: UIScreen.main.bounds.width * scale, height: UIScreen.main.bounds.height * scale)
    }
}

struct SelectedView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedView(selected: .constant(true))
    }
}
