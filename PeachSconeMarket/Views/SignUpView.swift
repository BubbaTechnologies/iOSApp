//
//  SignUpView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var api: Api
    var completionFunction: ()->Void
    var backFunction: ()->Void
    @ObservedObject private var signUpClass: SignUpClass = SignUpClass()
    @State private var confirmPassword: String = ""
    @State private var genderSelected:Bool = false
    @State private var errorMessage: String = ""
    @State private var verifyView: Bool = false
    @State private var verificationCode: String = ""
    var body: some View {
        ZStack{
            GeometryReader {reader in
                Color("BackgroundColor").ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    if !verifyView {
                        VStack(alignment: .center) {
                            Spacer(minLength: reader.size.height * 0.15)
                            TitleView()
                                .frame(height: max(125, reader.size.height * 0.2))
                            TextInputView(promptText: "Email", input: $signUpClass.username, secure: false)
                                .textContentType(.emailAddress)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            PickerView(selection: $signUpClass.gender, promptText: "Gender", options: api.filterOptionsStruct.getGenders().reversed(), selected: $genderSelected)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            TextInputView(promptText: "Password", input: $signUpClass.password, secure: true)
                                .textContentType(.newPassword)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            TextInputView(promptText: "Confirm Password", input: $confirmPassword, secure: true)
                                .textContentType(.newPassword)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            DatePickerView(placeholder: "Birthdate", birthdate: $signUpClass.birthdate)
                                .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                .padding(.bottom, reader.size.height * 0.01)
                            ButtonView(text: "Sign Up") {
                                if signUpClass.username.isEmpty || signUpClass.password.isEmpty || signUpClass.gender.isEmpty || confirmPassword.isEmpty {
                                    errorMessage = "Please fill in all fields."
                                    return
                                }
                                
                                if signUpClass.birthdate > Calendar.current.date(byAdding: .year, value: -13, to: Date())! {
                                    errorMessage = "Please fill your birthdate."
                                    return
                                }
                                
                                verify()
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
                                Link("Privacy Policy ", destination: URL(string: "https://www.peachsconemarket.com/privacypolicy/privacy_policy_tos.pdf")!)
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.03, relativeTo: .caption))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 0)
                                    .foregroundColor(.blue)
                                Text("and agree to the ")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.03, relativeTo: .caption))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("DarkFontColor"))
                                    .padding(.horizontal, 0)
                                Link("Terms of Service", destination: URL(string: "https://www.peachsconemarket.com/privacypolicy/privacy_policy_tos.pdf")!)
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
                        }.frame(height: reader.size.height)
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
                            .padding(.top, reader.size.height * 0.03)
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
        if confirmPassword != signUpClass.password {
            errorMessage = "You're supposed to type the same password to confirm."
            return
        }
        
        if !signUpClass.username.contains(/@[a-zA-Z-\.0]+\.[a-zA-Z]+$/) {
            errorMessage = "That's not an email!"
            return
        }
        
        do {
            if try api.requestVerification(userEmail: self.signUpClass.username) {
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
            if try api.sendSignUp(signUpClass: signUpClass, verificationCode: self.verificationCode) {
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

struct VerificationView: View {
    @Binding var verificationCode: String
    @Binding var viewIsPresent: Bool
    var buttonAction: ()->Void
    
    var body: some View {
        GeometryReader { reader in
            VStack (alignment: .center){
                Spacer()
                TitleView()
                    .frame(height: max(125, reader.size.height * 0.2))
                Text("Please enter the verification code sent to your email.")
                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.05, relativeTo: .body))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("DarkFontColor"))
                    .frame(width: reader.size.width * 0.9)
                TextInputView(promptText: "Verification Code", input: $verificationCode, secure: false)
                    .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                    .padding(.bottom, reader.size.height * 0.01)
                ButtonView(text: "Sign Up") {
                    viewIsPresent = false
                    buttonAction()
                }
                .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor))
                Spacer()
            }
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(api: Api(), completionFunction: {}, backFunction: {})
        VerificationView(verificationCode: .constant(""), viewIsPresent: .constant(true), buttonAction: {})
    }
}
