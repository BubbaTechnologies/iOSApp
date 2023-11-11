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
    var body: some View {
        ZStack{
            GeometryReader {reader in
                Color("BackgroundColor").ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center) {
                        Spacer(minLength: reader.size.height * 0.15)
                        TitleView()
                            .frame(height: max(125, reader.size.height * 0.2))
                        TextInputView(promptText: "Email", input: $signUpClass.username, secure: false)
                            .textContentType(.username)
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
                            
                            if signUpClass.birthdate <= Calendar.current.date(byAdding: .year, value: -13, to: Date())! {
                                errorMessage = "Please fill your birthdate."
                                return
                            }
                            
                            SignUp()
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
                }
                VStack(alignment: .leading){
                    Button(action: backFunction) {
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
    func SignUp() {
        if confirmPassword != signUpClass.password {
            errorMessage = "You're supposed to type the same password to confirm."
            return
        }
        
        if !signUpClass.username.contains(/@[a-zA-Z-\.0]+\.[a-zA-Z]+$/) {
            errorMessage = "That's not an email!"
            return
        }
        
        do {
            if try api.sendSignUp(signUpClass: signUpClass) {
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
    }
}
