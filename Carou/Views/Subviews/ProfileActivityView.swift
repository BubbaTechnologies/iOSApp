//
//  ProfileActivityView.swift
//  Carou
//
//  Created by Matt Groholski on 1/22/24.
//

import SwiftUI

struct ProfileActivityView: View {
    @Binding var profileInformation: ActivityProfileStruct?
    @StateObject var clothingManager: ClothingPageManager
    
    @State var errorMessage: String = ""
    @State var loading: Bool = false
    @State var safariItem: ClothingItem? = nil
    @State var previousItem: ClothingItem = ClothingItem()
    @State var startTime: Date?
    @State var buyAlertActive: Bool = false
    
    @State var buttonText: String = "Unfollow"
    
    var body: some View {
        GeometryReader { reader in
            ZStack{
                if profileInformation != nil {
                    ScrollView {
                            Circle()
                                .fill(Color("DarkBackgroundColor"))
                                .overlay{
                                    Text("\(profileInformation!.getInitials())")
                                        .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.2, relativeTo: .title))
                                        .foregroundColor(Color("DarkFontColor"))
                                }
                                .frame(width: reader.size.width * 0.5)
                                .padding(.bottom, reader.size.height * 0.01)
                            Text("\(profileInformation!.username)")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.075, relativeTo: .headline))
                                .foregroundColor(Color("DarkFontColor"))
                                .frame(width: reader.size.width * 0.9)
                                .padding(.bottom, reader.size.height * 0.01)
                            DynamicButtonView(text: $buttonText, widthFactor: 0.45) {
                                let currentFollowingStatus = self.profileInformation!.followingStatus
                                switch currentFollowingStatus {
                                case .following:
                                    //Unfollows user
                                    self.profileInformation!.followingStatus = .none
                                case .requested:
                                    //Unrequests user
                                    self.profileInformation!.followingStatus = .none
                                case .none:
                                    //Follows user
                                    if self.profileInformation!.privateAccount == true {
                                        self.profileInformation!.followingStatus = .requested
                                    } else {
                                        self.profileInformation!.followingStatus = .following
                                    }
                                }
                                
                                buttonText = ActivityProfileStruct.FollowingStatus.followingStatusToString(self.profileInformation!.followingStatus)
                                
                                do {
                                    try self.clothingManager.api.sendFollowRequest(newFollowingStatus: self.profileInformation!.followingStatus, userId: self.profileInformation!.id)
                                } catch {
                                    errorMessage = "Something went wrong! \(error)"
                                }
                            }
                            .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor))
                            Text("Activity")
                                .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.075, relativeTo: .title3))
                                .foregroundColor(Color("DarkFontColor"))
                        if self.profileInformation!.followingStatus == .following || self.profileInformation?.privateAccount == false {
                            if errorMessage.isEmpty && clothingManager.attemptedLoad {
                                CardCollectionView(items: $clothingManager.clothingItems) { index in
                                    let item = clothingManager.clothingItems[index]
                                    
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
                            } else if errorMessage.isEmpty {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                                    .scaleEffect(3)
                                    .frame(height: reader.size.height * 0.45)
                                    .onAppear{
                                        //Loads users activity list
                                        DispatchQueue.global(qos: .userInitiated).async{
                                            clothingManager.loadNext() { result in
                                                switch result {
                                                case .success(let empty):
                                                    if empty {
                                                        if clothingManager.clothingItems.count == 0 {
                                                            errorMessage = "No likes!"
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
                                Text("\(errorMessage)")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                                    .foregroundColor(.red)
                                    .padding(.top, reader.size.height * 0.2)
                                    .multilineTextAlignment(.center)
                            }
                        } else if profileInformation!.privateAccount && profileInformation!.followingStatus != .following {
                            Text("Private Account")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.075, relativeTo: .headline))
                                .foregroundColor(Color("DarkFontColor"))
                                .frame(width: reader.size.width * 0.9)
                                .padding(.top, reader.size.height * 0.2)
                                .padding(.bottom, reader.size.height * 0.01)
                        }
                    }
                    .onAppear{
                        self.clothingManager.userId = self.profileInformation!.id
                        self.buttonText = ActivityProfileStruct.FollowingStatus.followingStatusToString(self.profileInformation!.followingStatus)
                    }
                }
                VStack(alignment: .leading){
                    Button(action: {profileInformation = nil}) {
                        Image(systemName:"chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .padding(.leading, reader.size.width * 0.05)
                            .padding(.top, reader.size.height * 0.017)
                            .foregroundColor(Color("DarkFontColor"))
                            .frame(width: reader.size.width * 0.075)
                        Spacer()
                    }
                    Spacer()
                }
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
        }
    }
}

#Preview {
    ProfileActivityView(profileInformation: .constant(ActivityProfileStruct()), clothingManager: ClothingPageManager(clothingItems: ClothingItem.sampleItems))
}
