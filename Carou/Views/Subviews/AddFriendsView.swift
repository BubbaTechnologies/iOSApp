//
//  AddFriendsView.swift
//  Carou
//
//  Created by Matt Groholski on 1/23/24.
//

import SwiftUI

struct AddFriendsView: View {
    @ObservedObject var api: Api
    var changeFunction: (PageState)->Void
    
    @State var requestedProfiles: [ActivityProfileStruct] = []
    @State var loading = true
    @State var errorMessage = ""
    
    @State var searchViewActive: Bool = false
    
    @State var profileInformation: ActivityProfileStruct? = nil
    
    var body: some View {
        GeometryReader { reader in
            if !searchViewActive && profileInformation == nil {
                ZStack {
                    VStack(alignment: .center){
                        InlineTitleView()
                            .frame(width: reader.size.width, height: reader.size.height * 0.07)
                            .padding(.top, reader.size.height * 0.024)
                            .padding(.bottom, reader.size.height * 0.01)
                        ScrollView {
                            VStack {
                                Text("Requests")
                                    .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.075, relativeTo: .title3))
                                    .foregroundColor(Color("DarkFontColor"))
                                if errorMessage.isEmpty {
                                    if requestedProfiles.isEmpty && !loading {
                                        Text("No requests")
                                            .font(CustomFontFactory.getFont(style: "regular", size: reader.size.width * 0.075, relativeTo: .title3))
                                            .foregroundColor(Color("DarkFontColor"))
                                            .padding(.top, reader.size.height * 0.3)
                                    } else if loading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                                            .scaleEffect(3)
                                            .frame(height: reader.size.height * 0.65)
                                            .onAppear{
                                                DispatchQueue.global().async {
                                                    do {
                                                        try api.loadRequested() { items in
                                                            self.requestedProfiles = items
                                                            loading = false
                                                        }
                                                    } catch {
                                                        errorMessage = "Something isn't right: \(error)"
                                                    }
                                                }
                                            }
                                    } else {
                                        ForEach(requestedProfiles.indices, id: \.self) { index in
                                            AddView(username: requestedProfiles[index].username, buttonAction: { val in
                                                if val {
                                                    do {
                                                        try api.requestAction(userId: requestedProfiles[index].id, approved: true)
                                                        requestedProfiles.remove(at: index)
                                                    } catch {
                                                        print("Error in AddView addAction: \(error)")
                                                    }
                                                }
                                            }, usernameTapAction: {
                                                self.profileInformation = self.requestedProfiles[index]
                                            })
                                            .frame(height: reader.size.height * 0.05)
                                            
                                            //TODO: Deny Function
//                                            do {
//                                                try api.sendFollowRequest(newFollowingStatus: .following, userId: profiles[index].id)
//                                            } catch {
//                                                print("Something went wrong: \(error)")
//                                            }
                                        }
                                    }
                                } else {
                                    Spacer()
                                    Text("\(errorMessage)")
                                        .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }.frame(height: reader.size.height * 0.85)
                        NavigationButtonView(auxiliary: .constant((AuxiliaryType.none, AuxiliaryType.none)), buttonAction: navigationFunction)
                            .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                            .padding(.bottom, reader.size.height * NavigationViewDesignVariables.BOTTOM_PADDING_FACTOR)
                    }
                }.frame(width: reader.size.width, height: reader.size.height)
                
                VStack(alignment: .trailing){
                    HStack{
                        Spacer()
                        Button(action: {
                            searchViewActive = true
                        }) {
                            Image(systemName:"magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .padding(.trailing, reader.size.width * 0.05)
                                .padding(.top, reader.size.height * 0.01)
                                .foregroundColor(Color("DarkFontColor"))
                                .frame(width: reader.size.width * 0.1)
                        }
                    }
                    Spacer()
                }
            } else if self.profileInformation == nil {
                SearchUserView(viewActive: $searchViewActive, api: self.api)
                    .frame(width: reader.size.width, height: reader.size.height)
            } else {
                ProfileActivityView(profileInformation: $profileInformation, clothingManager: ClothingPageManager(api: self.api, requestType: .activity))
            }
        }
    }
}

extension AddFriendsView {
    func navigationFunction(pageState: PageState) {
        changeFunction(pageState)
    }
}

#Preview {
    AddFriendsView(api: Api(), changeFunction: {_ in})
}

