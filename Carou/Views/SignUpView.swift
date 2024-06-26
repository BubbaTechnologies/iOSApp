//
//  SignUpView.swift
//  Carou
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var api: Api
    var completionFunction: ()->Void
    var backFunction: ()->Void
    @ObservedObject private var userClass: UserClass = UserClass()
    @State private var confirmPassword: String = ""
    @State private var genderSelected:Bool = false
    @State private var errorMessage: String = ""
    @State private var verifyView: Bool = false
    @State private var verificationCode: String = ""
    
    @State var displayPermissionAlert: Bool = false
    var body: some View {
        ZStack{
            GeometryReader {reader in
                Color("BackgroundColor").ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    if !verifyView {
                        VStack(alignment: .center) {
                            Spacer(minLength: reader.size.height * 0.1)
                            TitleView()
                                .frame(height: max(125, reader.size.height * 0.2))
                            TextInputView(promptText: "Username", input: $userClass.username, secure: false)
                                .textContentType(.username)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            TextInputView(promptText: "Password", input: $userClass.password, secure: true)
                                .textContentType(.newPassword)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            TextInputView(promptText: "Confirm Password", input: $confirmPassword, secure: true)
                                .textContentType(.newPassword)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            TextInputView(promptText: "Email", input: $userClass.email, secure: false)
                                .textContentType(.emailAddress)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            PickerView(selection: $userClass.gender, promptText: "Preferred Clothing Gender", options: api.filterOptionsStruct.getGenders().sorted(), selected: $genderSelected)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            DatePickerView(placeholder: "Date of Birth", birthdate: $userClass.birthdate)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                            HStack {
                                Text("Optional")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.03, relativeTo: .caption))
                                    .foregroundColor(Color("DarkFontColor"))
                                    .padding(.leading,  reader.size.height * 0.055)
                                Spacer()
                            }
                            ButtonView(text: "Sign Up") {
                                if userClass.username.isEmpty || userClass.password.isEmpty || userClass.gender.isEmpty || confirmPassword.isEmpty || userClass.email.isEmpty {
                                    errorMessage = "Please fill in all fields."
                                    return
                                }
                                if self.userClass.dataCollectionPermission == nil && userClass.birthdate <= Calendar.current.date(byAdding: .year, value: -13, to: Date())! {
                                    displayPermissionAlert = true
                                } else {
                                    DispatchQueue.main.sync {
                                        self.userClass.dataCollectionPermission = false
                                    }
                                    verify()
                                }
                            }
                            .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor))
                            Text("\(errorMessage)")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .body))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Text("By signing up, you acknowledge that you have read the ")
                                .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.03, relativeTo: .caption))
                                .foregroundColor(Color("DarkFontColor"))
                                .multilineTextAlignment(.center)
                            HStack(spacing: 0){
                                Spacer()
                                Link("Privacy Policy ", destination: URL(string: "https://www.clothingcarou.com/privacypolicy/privacy_policy_tos.pdf")!)
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.03, relativeTo: .caption))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 0)
                                    .foregroundColor(.blue)
                                Text("and agree to the ")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.03, relativeTo: .caption))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("DarkFontColor"))
                                    .padding(.horizontal, 0)
                                Link("Terms of Service", destination: URL(string: "https://www.clothingcarou.com/privacypolicy/privacy_policy_tos.pdf")!)
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.03, relativeTo: .caption))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 0)
                                Text(".")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.03, relativeTo: .caption))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("DarkFontColor"))
                                    .padding(.horizontal, 0)
                                Spacer()
                                
                            }
                        }
                        .frame(height: reader.size.height)
                        .alert(isPresented: $displayPermissionAlert) {
                            Alert(
                                title: Text("Can we store your date of birth?"),
                                message: Text("This data will be used to help us better recommend clothing."),
                                primaryButton: .default(Text("No")){
                                    //Hides birthdate information
                                    self.userClass.dataCollectionPermission = false
                                    verify()
                                },
                                secondaryButton: .default(Text("Yes")){
                                    self.userClass.dataCollectionPermission = true
                                    verify()
                                })
                        }
                    } else {
                        VerificationView(verificationCode: $verificationCode, viewIsPresent: $verifyView, buttonAction: signUp)
                            .frame(height: reader.size.height)
                    }
                }
                VStack(alignment: .leading){
                    Button(action: verifyView ? {verifyView.toggle()} : backFunction) {
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

extension SignUpView {
    func verify() {
        if confirmPassword != userClass.password {
            errorMessage = "You're supposed to type the same password to confirm."
            return
        }
        
        if !userClass.email.contains(/@[a-zA-Z-\.0]+\.[a-zA-Z]+$/) {
            errorMessage = "That's not an email!"
            return
        }
        
        do {
            if try api.requestVerification(userEmail: self.userClass.email) {
                verifyView = true
            }
        } catch Api.ApiError.httpError(let message) {
            errorMessage = message
        } catch {
            errorMessage = "Something isn't right. Error Message: \(error)"
        }
    }
    
    func signUp() {
        do {
            if try api.sendSignUp(userClass: userClass, verificationCode: self.verificationCode) {
                completionFunction()
            } else {
                errorMessage = "You done goofed.\nTry again."
                return
            }
        } catch Api.ApiError.httpError(let message) {
            errorMessage = message
        } catch {
            errorMessage = "Something isn't right. Error Message: \(error)"
        }
        return
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(api: Api(), completionFunction: {}, backFunction: {})
        VerificationView(verificationCode: .constant(""), viewIsPresent: .constant(true), buttonAction: {})
    }
}
