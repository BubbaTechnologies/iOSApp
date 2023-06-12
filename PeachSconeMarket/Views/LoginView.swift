//
//  LoginView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI
import Foundation

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var signUpActive: Bool = false
    @State private var errorMessage: String  = ""
    @Binding var loggedIn: Bool
    @State private var loginDisabled: Bool = false
    
    var body: some View {
        switch signUpActive {
        case false:
            ZStack{
                Color("BackgroundColor").ignoresSafeArea()
                VStack(alignment: .center){
                    ScrollView(showsIndicators: false) {
                        Spacer(minLength: UIScreen.main.bounds.height * 0.25)
                        TitleView()
                            .padding(.bottom, 5)
                        TextInputView(promptText: "Email", input: $email, secure: false)
                            .textContentType(.username)
                        TextInputView(promptText: "Password", input: $password, secure: true)
                            .textContentType(.password)
                        ButtonView(text: "Sign In", action: SignIn)
                            .disabled(loginDisabled)
                        if !errorMessage.isEmpty {
                            Text("\(errorMessage)")
                                .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.04, relativeTo: .caption))
                                .foregroundColor(.red)
                        }
                        Spacer(minLength: UIScreen.main.bounds.height * 0.2)
                        ButtonView(text: "Sign Up", action: {signUpActive.toggle()})
                            .disabled(loginDisabled)
                    }
                }
                
                if loginDisabled {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                        .scaleEffect(3)
                }
            }
        case true:
            SignUpView(active: $signUpActive, loggedIn: $loggedIn)
        }
    }
}

extension LoginView{
    func SignIn()->Void {
        loginDisabled = true
        
        //Resets error message
        if (email.isEmpty || password.isEmpty) {
            errorMessage = "Fill in the above fields!"
            loginDisabled = false
            return
        }
        
        //Checks email format
        let emailRegex = /.+@.+\..+/
        if !email.contains(emailRegex) {
            errorMessage = "Invalid Email!"
            loginDisabled = false
            return
        }
        
        
        let loginStruct: LoginStruct = LoginStruct(username: email, password: password)
        do {
            let token: String = try LoginStruct.loginRequest(loginData: loginStruct)
            KeychainHelper.standard.save(Data(token.utf8), service: "access-token", account:"peachSconeMarket")
            loggedIn = true
        } catch HttpError.runtimeError(let message){
            errorMessage = "\(message)"
        } catch {
            errorMessage = "\(error)"
        }
        
        loginDisabled = false
        return
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedIn: .constant(false))
//        LoginView()
//                    .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
//                    .previewDisplayName("iPhone 14 Pro Max")
    }
}
