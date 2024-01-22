//
//  CardScrollView.swift
//  Carou
//
//  Created by Matt Groholski on 10/23/23.
//

import SwiftUI

struct CardScrollView: View {
    var name: String
    
    @StateObject var clothingManager: ClothingPageManager
    @ObservedObject var likeStore: LikeStore
    
    @Binding var selectedClothingItems: [Int]

    @Binding var editing: Bool
    @State var selectionDict: [Int:Bool] = [:]
    @State var loading: Bool = false
    
    @State var errorMessage: String = ""
    
    @State var isPresentingSafari:Bool = false
    @State var safariItem: ClothingItem? = nil
    @State var previousItem: ClothingItem = ClothingItem()
    @State var startTime: Date?
    @State var buyAlertActive: Bool = false

    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    Text(editing ? "Editing \(name)" : "\(name)")
                        .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.075, relativeTo: .title3))
                        .foregroundColor(Color("DarkFontColor"))
                    if errorMessage.isEmpty && clothingManager.attemptedLoad {
                        CardCollectionView(items: $clothingManager.clothingItems) { index in
                            if selectionDict[index] == nil {
                                selectionDict[index] = false
                            }
                            
                            let item = clothingManager.clothingItems[index]
                            
                            //Uploads interaction data
                            if editing {
                                self.selectionDict[index]!.toggle()
                                let selected = selectionDict[index]!
                                if selected {
                                    selectedClothingItems.append(item.id)
                                } else {
                                    selectedClothingItems = selectedClothingItems.filter{
                                        $0 != item.id
                                    }
                                }
                            } else {
                                if self.clothingManager.api.browser {
                                    //In-App Safari Browsing
                                    safariItem = item
                                } else {
                                    //External Browser
                                    if let url = URL(string: item.productURL) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }
                        }
                        .suboverlay(alignment: .leading) { index in
                            if editing {
                                SelectedView(selected: Binding<Bool>(
                                    get: {
                                        if let val = selectionDict[index] {
                                            return val
                                        } else {
                                            return false
                                        }
                                    },
                                    set: { value in
                                        selectionDict[index] = value
                                    }
                                ))
                                .frame(width: reader.size.width * 0.15, height: reader.size.height * 0.07)
                                .position(x: reader.frame(in: .local).minX + reader.size.width * 0.0425, y: reader.frame(in: .local).minY + reader.size.height * 0.01)
                                .onDisappear{
                                    selectionDict[index] = false
                                }
                            }
                        }
                        .frame(height: reader.size.height * (Double(
                            (clothingManager.clothingItems.count % 2 == 0 ? clothingManager.clothingItems.count : clothingManager.clothingItems.count + 1)) / 4.25))
                        if !clothingManager.allClothingItemsLoaded {
                            LazyVStack{
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                                    .scaleEffect(2)
                                    .onAppear{
                                        if !loading {
                                            loading = true
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                clothingManager.loadNext() { result in
                                                    switch result {
                                                    case .success(_):
                                                        break
                                                    case .failure(let error):
                                                        if case Api.ApiError.httpError(let message) = error {
                                                            errorMessage = message
                                                        } else {
                                                            errorMessage = "Something isn't right. Error Message: \(error)"
                                                        }
                                                    }
                                                }
                                                loading = false
                                            }
                                        }
                                    }
                            }
                            .frame(height: reader.size.height * 0.1)
                            EmptyView()
                                .frame(height: reader.size.height * 0.1)
                        }
                    } else if !clothingManager.attemptedLoad {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                            .scaleEffect(3)
                            .frame(height: reader.size.height * 0.9)
                    } else {
                        Spacer(minLength: reader.size.height * 0.4)
                        Text("\(errorMessage)")
                            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
            .alert(isPresented: $buyAlertActive) {
                //Presents alert to send api for buy
                Alert(
                    title: Text("Add to closet?")
                        .font(CustomFontFactory.getFont(style: "Bold", size: 22, relativeTo: .title))
                        .foregroundColor(Color("DarkFontColor")),
                    message: Text("Did you purchase \(self.previousItem.name)?")
                        .font(CustomFontFactory.getFont(style: "Normal", size: 16, relativeTo: .body))
                        .foregroundColor(Color("DarkFontColor")),
                    primaryButton: .default(Text("Yes")
                        .font(CustomFontFactory.getFont(style: "Normal", size: 16, relativeTo: .body))
                        .foregroundColor(Color("DarkFontColor"))) {
                        buyAlertActive = false
                        DispatchQueue.global(qos: .background).async {
                            //Sends buy like to server
                            let buyLike:LikeStruct = LikeStruct(clothingId: self.previousItem.id, imageTaps: 0, likeType: .bought)
                            do {
                                try clothingManager.api.sendLike(likeStruct: buyLike)
                            } catch {
                                self.likeStore.likes.append(buyLike)
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("No")
                        .font(CustomFontFactory.getFont(style: "Normal", size: 16, relativeTo: .body))
                        .foregroundColor(Color("DarkFontColor")))
                )
            }
            .sheet(isPresented: Binding<Bool> (
                //Controls sheet based on safariUrl
                //Sets to nil when the sheet is not presented
                get: {
                        self.safariItem != nil
                    },
                set: { isPresented in
                    if !isPresented {
                        if let startTime = self.startTime {
                            let elapsedTime = Date().timeIntervalSince(startTime)
                            if elapsedTime >= 20 {
                                self.previousItem = safariItem!
                                self.buyAlertActive = true
                            }
                            self.startTime = nil
                        }
                        self.safariItem = nil
                    }
                }
            )) {
                SafariView(url: Binding<URL>(
                    get: { URL(string: self.safariItem!.productURL)! },
                    set: {_ in return}
                )).onAppear() {
                   self.startTime = Date()
                }
            }
            .onAppear{
                DispatchQueue.global(qos: .userInitiated).async{
                    clothingManager.loadNext() { result in
                        switch result {
                        case .success(let empty):
                            if empty {
                                if clothingManager.clothingItems.count == 0 {
                                    errorMessage = "Start liking clothing!"
                                }
                            } 
                        case .failure(let error):
                            if case Api.ApiError.httpError(let message) = error {
                                errorMessage = message
                            } else {
                                errorMessage = "Something isn't right. Error Message: \(error)"
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CardScrollView(name: "Likes", clothingManager: ClothingPageManager(clothingItems: ClothingItem.sampleItems), likeStore: LikeStore(), selectedClothingItems: .constant([]), editing: .constant(false))
}
