//
//  LoginView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI
import Foundation

struct LoginView: View {
    @ObservedObject var api: Api
    var completionFunction:()->Void
    @ObservedObject private var loginClass: LoginClass = LoginClass()

    @State private var signUpActive: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        switch signUpActive {
        case false:
            ZStack{
                    GeometryReader{ reader in
                        Color("BackgroundColor").ignoresSafeArea()
                        ScrollView(showsIndicators: false) {
                            VStack{
                                Spacer(minLength: reader.size.height * 0.2)
                                TitleView()
                                    .frame(height: max(125, reader.size.height * 0.2))
                                TextInputView(promptText: "Email", input: $loginClass.username, secure: false)
                                    .textContentType(.username)
                                    .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                    .padding(.bottom, reader.size.height * 0.01)
                                TextInputView(promptText: "Password", input: $loginClass.password, secure: true)
                                    .textContentType(.password)
                                    .frame(height: max(LoginSequenceDesignVariables.fieldMinHeight, reader.size.height * LoginSequenceDesignVariables.fieldHeightFactor))
                                    .padding(.bottom, reader.size.height * 0.01)
                                ButtonView(text: "Sign In") {
                                    if loginClass.username.isEmpty || loginClass.password.isEmpty {
                                        errorMessage = "Fill in username and/or password."
                                        return
                                    }
                                    login()
                                }
                                .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor))
                                Text("\(errorMessage)")
                                    .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.04, relativeTo: .body))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                Spacer()
                                ButtonView(text: "Sign Up", action: {
                                    signUpActive = true
                                })
                                .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor))
                            }.frame(height: reader.size.height)
                        }
                }
            }
        case true:
            SignUpView(api: api, completionFunction: completionFunction, backFunction: {signUpActive = false})
        }
    }
}

extension LoginView {
    func login() {
        do {
            if try api.sendLogin(loginClass: loginClass) {
                completionFunction()
            } else {
                errorMessage = "Maybe try a different password?"
            }
        } catch Api.ApiError.httpError(let message) {
            errorMessage = message
        } catch {
            errorMessage = "Something isn't right. Error Message: \(error)"
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(api: Api(), completionFunction: {})
    }
}
