//
//  NavigationButtonView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import SwiftUI

struct NavigationButtonView: View {
    var showFilter: Bool
    var showEdit: Bool
    @Binding var options: Bool
    let buttonAction: (PageState)->Void
    
<<<<<<< HEAD
    @Binding public var state:pageState
    @Binding public var editing: Bool
    @Binding public var selectedItems: [Int]
    @ObservedObject public var paginator: ClothingItemPaginator
    @Binding public var filtering: Bool
    
    public var filterActions: (Bool,Bool)->Void
    
    private let scaleFactor: Double = 0.14
    private let padding: Double = 4.0
=======
    private let scaleFactor: Double = 0.7
    private let padding: Double = 3.0
>>>>>>> rebuild
    private let heightPadding: Double = 0.0025
    
    var body: some View {
        GeometryReader { reader in
            HStack{
                Spacer()
                //Exit/Filter Button
                ZStack{
                    if (showFilter || options) {
                        Button(action: {buttonAction(.filtering)}) {
                            Circle()
                                .fill(Color("DarkBackgroundColor"))
                                .overlay(
                                    ZStack{
                                        if (options) {
                                            Text("X")
                                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.08, relativeTo: .body))
                                                .foregroundColor(Color("DarkText"))
                                        } else {
                                            Image("FilterIcon")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color("DarkText"))
                                                .frame(height: reader.size.height * ((scaleFactor - 0.4) * 0.75))
                                        }
                                    }
                                )
                        }
                    } else  {
                        Circle()
                            .opacity(0)
                    }
                }.frame(height: reader.size.height * (scaleFactor * 0.75))
                    .padding(.horizontal, (padding))
                    .padding(.top, reader.size.height * heightPadding)
                
                //Likes View Button
                Button(action: {buttonAction(.likes)}) {
                    Circle()
                        .fill(Color("DarkBackgroundColor"))
                        .overlay(
                            Image("HeartIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * (scaleFactor - 0.125))
                                .offset(y: reader.size.height * 0.015)
                        )

                }.frame(height: reader.size.height * scaleFactor)
                    .padding(.horizontal, padding)
                    
                
                //Swipe View Button
                Button(action: {buttonAction(.swipe)}) {
                    Circle()
                        .fill(Color("DarkBackgroundColor"))
                        .overlay(
                            Image("SwipeIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * (scaleFactor - 0.22))
                        )
                }.frame(height: reader.size.height * scaleFactor)
                    .padding(.horizontal, padding)
                    
                
                //Collection View Button
                Button(action: {buttonAction(.collection)}) {
                    Circle()
                        .fill(Color("DarkBackgroundColor"))
                        .overlay(
                            Image("BagIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: reader.size.height * (scaleFactor - 0.2))
                        )
                }.frame(height: reader.size.height * scaleFactor)
                    .padding(.horizontal, padding)
                    
                
                //Confirm/Edit Button
                ZStack{
                    if (showEdit || options) {
                        Button(action: {buttonAction(.editing)}) {
                            Circle()
                                .fill(Color("DarkBackgroundColor"))
                                .overlay(
                                    ZStack{
                                        if (options) {
                                            Image(systemName:"checkmark")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color("DarkText"))
                                                .frame(height: reader.size.height * ((scaleFactor - 0.3) * 0.75))
                                                .offset(x: reader.size.width * -0.001)
                                        } else {
                                            Image("EditIcon")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color("DarkText"))
                                                .frame(height: reader.size.height * ((scaleFactor - 0.25) * 0.75))
                                                .offset(y: reader.size.height * -0.0015)
                                        }
                                    }
                                )

<<<<<<< HEAD
        state = .likes
        showEdit = true
        showFilter = true
    }
    
    func switchMainView() {
        state = .main
        showEdit = false
        showFilter = true
        editing = false
        filtering = false
        options = false
    }
    
    func switchCollectionView() {
        if (state != .collection) {
            editing = false
            options = false
        }
        
        //Removes filtering if button clicked
        if (!editing) {
            filtering = false
            options = false
        }
        
        state = .collection
        showEdit = false
        showFilter = false
    }
    
    func switchFilterView() {
        //Clicking X in edit mode
        if (editing && options) {
            editing = false
            options = false
            return
        }
        
        //X in filter mode
        if (filtering && options) {
            filterActions(false, true)
            filtering = false
            options = false
            return
        }
        
        //Start filter mode
        filterActions(false, false)
        filtering = true
        options = true
        return
    }
    
    func switchEditView() {
        //Checkmark edit mode
        if (editing && options) {
            for id in selectedItems {
                let likeStruct:LikeStruct = LikeStruct(clothingId: id, imageTapRatio: 0)
                do {
                    try LikeStruct.createLikeRequest(likeStruct: likeStruct, likeType: .removeLike)
                } catch  {
                    print("\(error)")
                }
            }
            
            //Removes all selected items from the view
            paginator.clothingItems = paginator.clothingItems.filter {
                !selectedItems.contains($0.id)
            }
            editing = false
            options = false
            return
        }
        
        //Checkmark filter mode
        if (filtering && options) {
            filterActions(true, true)
            filtering = false
            options = false
            return
=======
                        }
                    } else {
                        Circle()
                            .opacity(0)
                    }
                }.frame(height: reader.size.height * (scaleFactor * 0.75))
                    .padding(.horizontal, padding)
                    .padding(.top, reader.size.height * heightPadding)
                Spacer()
            }.position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY - reader.size.height * 0.05)
>>>>>>> rebuild
        }
    }
}

struct NavigationButtonView_Previews: PreviewProvider {
    static var previews: some View {
<<<<<<< HEAD
        NavigationButtonView(showEdit: true, showFilter: true, state: .constant(.main), editing: .constant(false), selectedItems: .constant([]), paginator: ClothingItemPaginator(requestType: .likes, clothingItems: ClothingItem.sampleItems), filtering: .constant(false), filterActions: {(_, _) in return})
=======
        NavigationButtonView(showFilter: true, showEdit: true, options: .constant(false), buttonAction: {_ in return})
>>>>>>> rebuild
    }
}
