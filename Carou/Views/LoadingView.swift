//
//  ContentView.swift
//  Carou
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct LoadingView: View {
    var versionNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    @State var imageIndex = 0;
    let images = [Image("LoadingA"), Image("LoadingB")]
    
    
    var body: some View {
        ZStack{
            GeometryReader{ reader in
                Color("BackgroundColor").ignoresSafeArea()
                VStack(alignment: .center){
                    Spacer()
                    images[imageIndex]
                        .scaledToFit()
                        .frame(width: reader.size.width)
                        .onAppear{
                            Timer.scheduledTimer(withTimeInterval: 0.155, repeats: true){ timer in
                                self.imageIndex = (self.imageIndex + 1) % images.count
                            }
                        }
                    Spacer()
                    Text("Version: \(versionNumber)")
                        .font(CustomFontFactory.getFont(style: "Regular", size: 18, relativeTo: .body))
                        .foregroundColor(Color("DarkFontColor"))
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
