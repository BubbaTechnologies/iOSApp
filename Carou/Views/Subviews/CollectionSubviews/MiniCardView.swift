//
//  MiniCardView.swift
//  Carou
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct MiniCardView: View {
    public var item: ClothingItem
    var tapAction: ()->Void
    
    private let widthFactor: Double = 0.35
    private let heightFactor: Double = 0.3
    
    var body: some View {
        GeometryReader { reader in
            ZStack{
                VStack{
                    CustomAsyncImage(url: URL(string: item.imageURL[0])) { phase in
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
                                Text("This is taking longer than normal...")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.08, relativeTo: .caption))
                            @unknown default:
                                EmptyView()
                            }
                        }
                    .frame(width:reader.size.width, height: reader.size.height * 0.75)
                        .background(Color("LightFontColor"))
                        .cornerRadius(reader.size.height * 0.05)
                        .onTapGesture {
                            tapAction()
                        }
                        HStack{
                            Text("\(item.name)")
                                .lineLimit(4)
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.13, relativeTo: .body))
                                .multilineTextAlignment(TextAlignment.leading)
                                .foregroundColor(Color("DarkFontColor"))
                            Spacer()
                        }
                        Spacer()
                    }.frame(width: reader.size.width, height: reader.size.height)
            }
        }
    }
}

struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(item:ClothingItem.sampleItems[0], tapAction: {})
    }
}
