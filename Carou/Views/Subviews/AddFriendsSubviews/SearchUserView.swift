//
//  SearchUserView.swift
//  Carou
//
//  Created by Matt Groholski on 1/23/24.
//

import SwiftUI

struct SearchUserView: View {
    @Binding var viewActive: Bool
    @ObservedObject var api: Api
    
    @State var query: String = ""
    @State var profiles: [ActivityProfileStruct] = []
    @State var errorMessage = ""
    @State var loading = false
    
    @State var profileInformation: ActivityProfileStruct? = nil
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            if profileInformation == nil {
                ZStack {
                    VStack{
                        Text("User Search")
                            .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.075, relativeTo: .title3))
                            .foregroundColor(Color("DarkFontColor"))
                        TextInputView(promptText: "Username", input: $query, secure: false)
                            .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                        SmallButtonView(text: "Search", confirmation: false) {
                            loading = true
                            do {
                                try api.searchUsers(query: query) { profiles in
                                    self.profiles = profiles
                                }
                            } catch {
                                errorMessage = "Something went wrong. \(error)"
                            }
                            loading = false
                        }
                        .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight * 0.9, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor * 0.9))
                        ScrollView {
                            if errorMessage.isEmpty {
                                if !profiles.isEmpty {
                                    ForEach(profiles.indices, id: \.self) { index in
                                        AddView(username: profiles[index].username, buttonAction: { val in
                                            if val {
                                                do {
                                                    try api.sendFollowRequest(newFollowingStatus: .following, userId: profiles[index].id)
                                                } catch {
                                                    print("Something went wrong: \(error)")
                                                }
                                            } else {
                                                do {
                                                    try api.sendFollowRequest(newFollowingStatus: .none, userId: profiles[index].id)
                                                } catch {
                                                    print("Something went wrong: \(error)")
                                                }
                                            }
                                        }, usernameTapAction: {
                                            profileInformation = profiles[index]
                                        }, confirmed: profiles[index].followingStatus != .none)
                                        .frame(height: reader.size.height * 0.05)
                                        .padding(.vertical, 0)
                                    }
                                } else if loading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkFontColor")))
                                        .scaleEffect(3)
                                        .frame(width:reader.size.width, height: reader.size.height * 0.6)
                                }
                            } else {
                                Text("\(errorMessage)")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                        }.frame(height: reader.size.height * 0.85)
                    }
                    
                    VStack(alignment: .leading){
                        //Switches view to swipe
                        Button(action: {viewActive = false}) {
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
            } else {
                ProfileActivityView(profileInformation: $profileInformation, clothingManager: ClothingPageManager(api: self.api, requestType: .activity))
            }
        }
    }
}

#Preview {
    SearchUserView(viewActive: .constant(true), api: Api())
}
