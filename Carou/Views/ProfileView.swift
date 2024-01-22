//
//  SettingsView.swift
//  Carou
//
//  Created by Matt Groholski on 11/20/23.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var api: Api
    @ObservedObject var userClass: UserClass
    @State private var confirmPassword: String = ""
    @State private var genderSelected:Bool = false
    var changeFunction: (PageState)->Void
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    @State var displayErrorMessage = false
    @State var errorMessage = ""
    
    init(api: Api, changeFunction: @escaping (PageState)->Void) {
        self.api = api
        self.userClass = UserClass(from: api.profileInformation)
        self.changeFunction = changeFunction
    }
    
    var body: some View {
        GeometryReader {reader in
            Color("BackgroundColor").ignoresSafeArea()
            ZStack {
                VStack{
                    ScrollView{
                            VStack{
                                Circle()
                                    .fill(Color("DarkBackgroundColor"))
                                    .overlay{
                                        Text("\(api.profileInformation.getInitials())")
                                            .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.2, relativeTo: .title))
                                            .foregroundColor(Color("DarkFontColor"))
                                    }
                                    .frame(width: reader.size.width * 0.5)
                                    .padding(.bottom, reader.size.height * 0.01)
                                TextInputView(promptText: userClass.username, input: $userClass.username, secure: false)
                                    .textContentType(.username)
                                    .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                    .padding(.bottom, reader.size.height * 0.01)
                                TextInputView(promptText: "New Password", input: $userClass.password, secure: true)
                                    .textContentType(.newPassword)
                                    .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                    .padding(.bottom, reader.size.height * 0.01)
                                TextInputView(promptText: "Confirm Password", input: $confirmPassword, secure: true)
                                    .textContentType(.newPassword)
                                    .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                    .padding(.bottom, reader.size.height * 0.01)
                                TextInputView(promptText: userClass.email, input: $userClass.email, secure: false)
                                    .textContentType(.emailAddress)
                                    .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                    .padding(.bottom, reader.size.height * 0.01)
                                PickerView(selection: $userClass.gender, promptText: userClass.gender, options: FilterOptionsStruct.sampleOptions.getGenders().sorted(), selected: $genderSelected)
                                    .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                    .padding(.bottom, reader.size.height * 0.01)
                                DatePickerView(placeholder: userClass.dataCollectionPermission! ? dateFormatter.string(from: userClass.birthdate) : "Date of Birth", birthdate: $userClass.birthdate)
                                    .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                    .padding(.bottom, reader.size.height * 0.01)
                                ButtonView(text: "Update", confirmation: false, widthFactor: 0.5, fontFactor: 0.06) {
                                    self.updateProfile(from: self.userClass)
                                    DispatchQueue.global(qos: .background).async {
                                        do {
                                            try api.sendUpdate(userClass: self.userClass)
                                            try api.loadProfile()
                                        } catch {
                                            print("Error in updating: \(error)")
                                        }
                                    }
                                }
                                .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight * 0.9, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor * 0.9))
                                Text("Account Actions")
                                    .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.075, relativeTo: .title3))
                                    .foregroundColor(Color("DarkFontColor"))
                                ButtonView(text: "Logout", confirmation: true, widthFactor: 0.5, fontFactor: 0.06) {
                                    KeychainHelper.standard.delete(service: "access-token", account: "clothingCarou")
                                    exit(0)
                                }
                                .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight * 0.95, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor * 0.95))
                                
                                ButtonView(text: "Delete", confirmation: true, widthFactor: 0.5, fontFactor: 0.06) {
                                    do {
                                        let responseValue = try api.deleteAccount()
                                        if responseValue == false {
                                            errorMessage = "Could not delete account."
                                            displayErrorMessage = true
                                        } else {
                                            KeychainHelper.standard.delete(service: "access-token", account: "clothingCarou")
                                            exit(0)
                                        }
                                    } catch {
                                        errorMessage = "\(error)"
                                        displayErrorMessage = true
                                    }
                                }
                                .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight * 0.95, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor * 0.95))
                            }
                    }.frame(width: reader.size.width ,height: reader.size.height * (0.85 + NavigationViewDesignVariables.frameHeightFactor), alignment: .center)
                }
                .frame(width: reader.size.width, height: reader.size.height)
                VStack(alignment: .leading){
                    Button(action: {changeFunction(.swipe)}) {
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
        }
    }
}

extension ProfileView {
    func updateProfile(from user: UserClass) {
        self.api.profileInformation = ProfileStruct(username: user.username, email: user.email, gender: user.gender, birthdate: user.birthdate.ISO8601Format(), privateAccount: false)
    }
}





#Preview {
    ProfileView(api: Api(), changeFunction: {_ in return})
}
