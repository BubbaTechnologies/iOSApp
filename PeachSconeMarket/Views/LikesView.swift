//
//  LikesView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct LikesView: View {
    @State var errorMessage: String = ""
    
    @ObservedObject var paginator: ClothingItemPaginator
    @Binding var selectedItems: [Int]
    @Binding var isPresentingSafari:Bool
    @Binding var safariUrl: URL
    @Binding var editing: Bool
    
    @State private var contentHeight: CGFloat = 0.0
    private let firstPageMultiplier: CGFloat = 1.86522
    private let nextPageMultiplier: CGFloat = 2.614383
    @State private var loading: Bool = true
    @State private var more: Bool = true
    
    @Namespace var collectionID
    
    var body: some View {
        ZStack{
            ScrollViewReader{ proxy in
                ScrollView(showsIndicators: false) {
                    GeometryReader{ geometry in
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: loading ? CGPoint(x:0, y:0) : geometry.frame(in: .named("scrollView")).origin)
                    }.frame(width: 0, height: 0)
                    VStack{
                        InlineTitleView()
                            .frame(alignment: .top)
                            .padding(.bottom, UIScreen.main.bounds.height * 0.001)
                        Text(editing ? "Editing Likes" : "Likes")
                            .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.075, relativeTo: .title3))
                            .foregroundColor(Color("DarkText"))
                        CardCollectionView(items: $paginator.clothingItems, isPresentingSafari: $isPresentingSafari, safariUrl: $safariUrl, editing: $editing, selectedItems: $selectedItems)
                        EmptyView()
                            .id(collectionID)
                            .padding(.horizontal, UIScreen.main.bounds.width * 0.025)
                        if loading && more {
                            ProgressView()
                                .frame(height: UIScreen.main.bounds.height * 0.05)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                                .scaleEffect(1.25)
                        }
                    }
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear{
                            contentHeight = geometry.size.height
                        }
                })
                .coordinateSpace(name: "scrollView")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    if (!loading) {
                        loading = true
                        let pageNumber: CGFloat =  CGFloat(paginator.currentPage - 1)
                        let perPage: CGFloat = contentHeight * (pageNumber * nextPageMultiplier)
                        let initial: CGFloat = contentHeight * firstPageMultiplier
                        if (abs(value.y) >=  perPage + initial) {
                            do {
                                more = try paginator.loadNextPage()
                                proxy.scrollTo(collectionID)
                            } catch HttpError.runtimeError(let message) {
                                errorMessage = "\(message)"
                                paginator.clothingItems.removeAll()
                            } catch {
                                errorMessage = "\(error)"
                            }
                        }
                        loading = false
                    }
                }
            }
            if paginator.clothingItems.count == 0 && errorMessage.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.01)
                    .onAppear{
                        do {
                            _ = try paginator.loadNextPage()
                            loading = false
                        } catch HttpError.runtimeError(let message) {
                            errorMessage = "\(message)"
                        } catch {
                            errorMessage = "\(error)"
                        }
                    }
            }
            if !errorMessage.isEmpty {
                Text("\(errorMessage)")
                    .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.04, relativeTo: .caption))
                    .foregroundColor(.red)
            }
        }.onDisappear{
            paginator.reset()
        }
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: ()->CGPoint){}
}


struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView(paginator: ClothingItemPaginator(requestType: .likes, clothingItems: ClothingItem.sampleItems),selectedItems: .constant([0]), isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!), editing: .constant(true))
        LikesView(paginator: ClothingItemPaginator(requestType: .likes, clothingItems: ClothingItem.sampleItems), selectedItems: .constant([0]), isPresentingSafari: .constant(false), safariUrl: .constant(URL(string: "https://www.peachsconemarket.com")!), editing: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")
    }
}



