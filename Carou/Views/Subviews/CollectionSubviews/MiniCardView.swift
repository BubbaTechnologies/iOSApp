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
    
    @EnvironmentObject var api: Api
    
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
                                Text("Just tap?\n We've taken note...")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.08, relativeTo: .caption))
                                    .foregroundColor(Color("DarkFontColor"))
                                    .multilineTextAlignment(.center)
                                    .onAppear{
                                        DispatchQueue.global(qos: .background).async {
                                            do {
                                                try api.sendImageError(clothingId: item.id)
                                            } catch {
                                                print("\(error)")
                                            }
                                        }
                                    }
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
