//
//  NavigationButtonView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct NavigationButtonView: View {
    @State public var showEdit: Bool
    @State public var showFilter: Bool
    
    @Binding public var state:pageState
    @Binding public var editing: Bool
    @Binding public var selectedItems: [Int]
    @Binding public var collectionItems: [ClothingItem]
    
    private let scaleFactor: Double = 0.14
    private let padding: Double = 4.0
    private let heightPadding: Double = 0.0025
    
    var body: some View {
        HStack{
            Spacer()
            ZStack{
                if (showFilter) {
                    Button(action: switchFilterView) {
                        Circle()
                            .fill(Color("DarkBackgroundColor"))
                            .overlay(
                                ZStack{
                                    if editing == true {
                                        Text("X")
                                            .font(CustomFontFactory.getFont(style: "Regular", size: UIScreen.main.bounds.width * 0.08, relativeTo: .body))
                                            .foregroundColor(Color("DarkText"))
                                    } else {
                                        Image("FilterIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color("DarkText"))
                                            .frame(width: UIScreen.main.bounds.width * (scaleFactor * 0.75 - 0.04), height: UIScreen.main.bounds.height * (scaleFactor * 0.75 - 0.04))
                                    }
                                }
                            )
                    }
                } else  {
                    EmptyView()
                }
            }.frame(width: UIScreen.main.bounds.width * (scaleFactor * 0.75), height: UIScreen.main.bounds.height * (scaleFactor * 0.75))
                .padding(.horizontal, (padding * 0.25))
                .padding(.top, UIScreen.main.bounds.height * heightPadding)
            Button(action: switchLikesView) {
                Circle()
                    .fill(Color("DarkBackgroundColor"))
                    .overlay(
                        Image("HeartIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * (scaleFactor - 0.03), height: UIScreen.main.bounds.height * (scaleFactor - 0.03))
                    )
                
            }.frame(width: UIScreen.main.bounds.width * scaleFactor, height: UIScreen.main.bounds.height * scaleFactor)
                .padding(.horizontal, padding)
            Button(action: switchMainView) {
                Circle()
                    .fill(Color("DarkBackgroundColor"))
                    .overlay(
                        Image("SwipeIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * (scaleFactor - 0.05), height: UIScreen.main.bounds.height * (scaleFactor - 0.05))
                    )
            }.frame(width: UIScreen.main.bounds.width * scaleFactor, height: UIScreen.main.bounds.height * scaleFactor)
                .padding(.horizontal, padding)
            Button(action: switchCollectionView) {
                Circle()
                    .fill(Color("DarkBackgroundColor"))
                    .overlay(
                        Image("BagIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * (scaleFactor - 0.04), height: UIScreen.main.bounds.height * (scaleFactor - 0.04))
                    )
            }.frame(width: UIScreen.main.bounds.width * scaleFactor, height: UIScreen.main.bounds.height * scaleFactor)
                .padding(.horizontal, padding)
            ZStack{
                if (showEdit) {
                    Button(action: switchEditView) {
                        Circle()
                            .fill(Color("DarkBackgroundColor"))
                            .overlay(
                                ZStack{
                                    if (editing) {
                                        Image(systemName:"checkmark")
                                            .resizable()
                                            .scaledToFill()
                                            .foregroundColor(Color("DarkText"))
                                            .frame(width: UIScreen.main.bounds.width * (scaleFactor * 0.18), height: UIScreen.main.bounds.height * (scaleFactor * 0.18))
                                    } else {
                                        Image("EditIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color("DarkText"))
                                            .frame(width: UIScreen.main.bounds.width * ((scaleFactor * 0.75) - 0.05), height: UIScreen.main.bounds.height * ((scaleFactor * 0.75) - 0.05))
                                    }
                                }
                            )
                        
                    }
                } else {
                    EmptyView()
                }
            }.frame(width: UIScreen.main.bounds.width * (scaleFactor * 0.75), height: UIScreen.main.bounds.height * (scaleFactor * 0.75))
                .padding(.horizontal, padding * 0.25)
                .padding(.top, UIScreen.main.bounds.height * heightPadding)
            Spacer()
        }
    }
}

extension NavigationButtonView {
    func switchLikesView() {
        if state != .likes {
            editing = false
        }
        state = .likes
        showEdit = true
        showFilter = true
    }
    
    func switchMainView() {
        state = .main
        showEdit = false
        showFilter = true
        editing = false
    }
    
    func switchCollectionView() {
        if state != .collection {
            editing = false
        }
        
        state = .collection
        showEdit = true
        showFilter = true
    }
    
    func switchFilterView() {
        if (editing) {
            editing = false
            return
        }
        editing = false
    }
    
    func switchEditView() {
        if editing {
            for id in selectedItems {
                let likeStruct:LikeStruct = LikeStruct(clothingId: String(id), rating: String(0))
                do {
                   try LikeStruct.updateLikeRequest(likeStruct: likeStruct)
                } catch  {
                    print("\(error)")
                }
            }
            collectionItems = collectionItems.filter {
                !selectedItems.contains($0.id)
            }
            editing = false
            return
        }
        editing.toggle()
    }
}

struct NavigationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButtonView(showEdit: true, showFilter: true, state: .constant(.main), editing: .constant(false), selectedItems: .constant([]), collectionItems: .constant([]))
    }
}
