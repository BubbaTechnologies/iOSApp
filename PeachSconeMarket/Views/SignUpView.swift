//
//  SignUpView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var api: Api
    @Binding var appStage: PeachSconeMarketApp.stage
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
                            .frame(height: max(PeachSconeMarketApp.fieldMinHeight, reader.size.height * PeachSconeMarketApp.fieldHeightFactor))
                            .padding(.bottom, reader.size.height * 0.01)
                        PickerView(selection: $signUpClass.gender, promptText: "Gender", options: api.getGenderOptions(), selected: $genderSelected)
                            .frame(height: max(PeachSconeMarketApp.fieldMinHeight, reader.size.height * PeachSconeMarketApp.fieldHeightFactor))
                            .padding(.bottom, reader.size.height * 0.01)
                        TextInputView(promptText: "Password", input: $signUpClass.password, secure: true)
                            .textContentType(.newPassword)
                            .frame(height: max(PeachSconeMarketApp.fieldMinHeight, reader.size.height * PeachSconeMarketApp.fieldHeightFactor))
                            .padding(.bottom, reader.size.height * 0.01)
                        TextInputView(promptText: "Confirm Password", input: $confirmPassword, secure: true)
                            .textContentType(.newPassword)
                            .frame(height: max(PeachSconeMarketApp.fieldMinHeight, reader.size.height * PeachSconeMarketApp.fieldHeightFactor))
                            .padding(.bottom, reader.size.height * 0.01)
                        ButtonView(text: "Sign Up") {
                            if signUpClass.username.isEmpty || signUpClass.password.isEmpty || signUpClass.gender.isEmpty || confirmPassword.isEmpty {
                                errorMessage = "Please fill in all fields."
                                return
                            }
                            SignUp()
                        }
                        .frame(height: max(PeachSconeMarketApp.buttonMinHeight, reader.size.height * PeachSconeMarketApp.buttonHeightFactor))
                        Text("\(errorMessage)")
                            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .body))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }.frame(height: reader.size.height)
                }
            }
        }
    }
}

extension SignUpView {
    func SignUp() {
        if confirmPassword != signUpClass.password {
            errorMessage = "I think you're supposed to type the same password to confirm."
            return
        }
        
        do {
            if try api.sendSignUp(signUpClass: signUpClass) {
                appStage = .loading
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
        SignUpView(api: Api(), appStage: .constant(.authentication))
    }
}
