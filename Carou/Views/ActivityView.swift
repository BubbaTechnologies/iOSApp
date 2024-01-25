//
//  ActivityView.swift
//  Carou
//
//  Created by Matt Groholski on 1/16/24.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var activityManager: ActivityManager
    @Binding var pageState: PageState
    @ObservedObject var likeStore: LikeStore
    var changeFunction: (PageState)->Void

    @State var loading: Bool = false
    @State var errorMessage: String = ""
    @State var safariItem: ClothingItem? = nil
    @State var previousItem: ClothingItem = ClothingItem()
    @State var startTime: Date?
    @State var buyAlertActive: Bool = false
    
    
    //ProfileActivityInformation
    @State var profileInformation: ActivityProfileStruct? = nil
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            if profileInformation == nil {
                VStack(alignment: .center){
                    InlineTitleView()
                        .frame(width: reader.size.width, height: reader.size.height * 0.07)
                        .padding(.top, reader.size.height * 0.024)
                        .padding(.bottom, reader.size.height * 0.01)
                    ScrollView {
                        VStack{
                            Text("Activity")
                                .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.075, relativeTo: .title3))
                                .foregroundColor(Color("DarkFontColor"))
                            
                            if errorMessage.isEmpty && activityManager.attemptedLoad {
                                CardCollectionView(items: Binding<[ClothingItem]>(
                                    get: {
                                        activityManager.activityItems.map{ $0.clothingItem }
                                    },
                                    set: { _ in
                                            //Nothing changes when this is not set.
                                    }
                                
                                )) { index in
                                    let item = activityManager.activityItems[index].clothingItem
                                    if self.activityManager.api.browser {
                                        //In-App Safari Browsing
                                        safariItem = item
                                    } else {
                                        //External Browser
                                        if let url = URL(string: item.productURL) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                                .suboverlay(alignment: .leading) { index in
                                    Circle()
                                        .fill(Color("LightFontColor"))
                                        .overlay {
                                            Text("\(activityManager.activityItems[index].profile.getInitials())")
                                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .caption))
                                                .foregroundColor(Color("DarkFontColor"))
                                        }
                                        .frame(width: reader.size.width * 0.15, height: reader.size.height * 0.06)
                                        .position(x: reader.frame(in: .local).minX + reader.size.width * 0.02, y: reader.frame(in: .local).minY + reader.size.height * 0.01)
                                        .onTapGesture {
                                            self.profileInformation = self.activityManager.activityItems[index].profile
                                        }
                                }
                                .frame(height: reader.size.height * (Double(
                                    (activityManager.activityItems.count % 2 == 0 ? activityManager.activityItems.count : activityManager.activityItems.count + 1)) / 4.25))
                                if !activityManager.allItemsLoaded {
                                    LazyVStack{
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                                            .scaleEffect(2)
                                            .onAppear{
                                                if !loading {
                                                    loading = true
                                                    DispatchQueue.global(qos: .userInitiated).async {
                                                        self.activityManager.loadNext() { result in
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
                            } else if !activityManager.attemptedLoad {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                                    .scaleEffect(3)
                                    .frame(height: reader.size.height * 0.9)
                            } else {
                                Spacer(minLength: reader.size.height * GeneralDesignVariables.errorMessageHeightRatio)
                                Text("\(errorMessage)")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }.frame(height: reader.size.height * 0.85, alignment: .center)
                    NavigationButtonView(auxiliary: .constant((AuxiliaryType.filtering, AuxiliaryType.adding)), buttonAction: navigationFunction)
                        .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                        .padding(.bottom, reader.size.height * NavigationViewDesignVariables.BOTTOM_PADDING_FACTOR)
                }
                .frame(width: reader.size.width, height: reader.size.height)
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
                                    try activityManager.api.sendLike(likeStruct: buyLike)
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
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
                .onAppear{
                    DispatchQueue.global(qos: .userInitiated).async{
                        self.activityManager.loadNext() { result in
                            switch result {
                            case .success(let empty):
                                if empty {
                                    if self.activityManager.activityItems.count == 0 {
                                        errorMessage = "Follow some people!"
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
            } else {
                ProfileActivityView(profileInformation: $profileInformation, clothingManager: ClothingPageManager(api: self.activityManager.api, requestType: .activity))
            }
        }
    }
}

extension ActivityView {
    func navigationFunction(pageState: PageState) {
        changeFunction(pageState)
    }
}

#Preview {
    ActivityView(activityManager: ActivityManager(clothingItems: ClothingItem.sampleItems), pageState: .constant(.activity),likeStore: LikeStore() ,changeFunction: {_ in return})
}
