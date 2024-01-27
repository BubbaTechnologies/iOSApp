//
//  SelectedView.swift
//  Carou
//
//  Created by Matt Groholski on 5/16/23.
//

import SwiftUI

struct SelectedView: View {
    @Binding public var selected: Bool
    private let scale: Double = 0.48
    
    var body: some View {
        GeometryReader { reader in
            ZStack{
                Circle()
                    .fill(Color("LightFontColor"))
                    .overlay{
                        ZStack{
                            if (selected) {
                                Image(systemName:"checkmark")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color("DarkFontColor"))
                                    .frame(width:abs(reader.size.width * scale), height: reader.size.height * scale)
                                    .offset(x: reader.size.width * -0.0045)
                            }
                        }
                    }
            }
        }
    }
}

struct SelectedView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedView(selected: .constant(true))
    }
}
