//
//  CardImageView.swift
//  Carou
//
//  Created by Matt Groholski on 9/27/23.
//

import SwiftUI

struct CardImageView: View {
    static let widthFactor: Double = 0.9
    
    @EnvironmentObject var api: Api
    @State var sentError = false
    
    var itemId: Int
    var imageUrl: String

    var body: some View {
        GeometryReader { reader in
            CustomAsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                        .scaleEffect(3)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                case .failure:
                    Text("Something isn't right.\n We've taken note...")
                        .foregroundColor(Color("DarkFontColor"))
                        .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .caption))
                        .multilineTextAlignment(.center)
                        .multilineTextAlignment(.center)
                        .onAppear{
                            if !sentError {
                                DispatchQueue.global(qos: .background).async {
                                    do {
                                        try api.sendImageError(clothingId: itemId)
                                    } catch {
                                        print("\(error)")
                                    }
                                }
                                sentError = true
                            }
                        }
                @unknown default:
                    Text("This is taking longer than normal...")
                        .foregroundColor(Color("DarkFontColor"))
                        .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .caption))
                }
            }
            .padding(.horizontal, 20)
            .frame(width: reader.size.width * CardView.widthFactor, height: reader.size.height, alignment: .center)
            .background(Color("LightFontColor"))
            .cornerRadius(CardView.heightFactor * 30.5)
            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}

