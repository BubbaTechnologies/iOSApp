//
//  CardImageView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 9/27/23.
//

import SwiftUI

struct CardImageView: View {
    static let widthFactor: Double = 0.9
    var imageUrl: String
    var body: some View {
        GeometryReader { reader in
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                        .scaleEffect(3)
                case .success(let image):
                    ProcessedImageView(image: image)
                case .failure:
                    Text("This is taking longer than normal...")
                        .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .caption))
                        .foregroundColor(Color("DarkFontColor"))
                @unknown default:
                    Text("This is taking longer than normal...")
                        .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .caption))
                        .foregroundColor(Color("DarkFontColor"))
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

