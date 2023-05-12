//
//  SignUpView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct SignUpView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @Binding var active:Bool
    @Binding var loggedIn: Bool
    @State var signUpDisabled:Bool = false
    @State var gender: String = "Other"
    @State var genderSelected: Bool = false
    @State var errorMessage: String = ""
    
    let genderOptions = ["Male","Female","Other"]
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center) {
                Spacer()
                TitleView()
                    .padding(.bottom, 5)
                TextInputView(promptText: "Name", input: $name, secure: false)
                TextInputView(promptText: "Email", input: $email, secure: false)
                PickerView(selection: $gender, promptText: "Gender", options: genderOptions, selected: $genderSelected)
                TextInputView(promptText: "Password", input: $password, secure: true)
                TextInputView(promptText: "Confirm Password", input: $confirmPassword, secure: true)
                ButtonView(text: "Sign Up", action: SignUp)
                    .onTapGesture {
                        signUpDisabled = true
                        errorMessage = ""
                    }
                    .disabled(signUpDisabled)
                if !errorMessage.isEmpty {
                    Text("\(errorMessage)")
                        .font(CustomFontFactory.getFont(style: "Bold", size: 15))
                        .foregroundColor(.red)
                }
                Spacer()
            }
            VStack(alignment: .leading){
                Button(action: {active.toggle()}) {
                    Image(systemName:"chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 20)
                        .foregroundColor(Color("DarkText"))
                        .frame(width: UIScreen.main.bounds.width * 0.08)
                    Spacer()
                }
                Spacer()
            }
            if signUpDisabled {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
            }
        }
    }
}

extension SignUpView {
    func SignUp() {
        if (password != confirmPassword) {
            errorMessage = "Passwords do not match!"
            signUpDisabled = false
            return
        }
        
        if (password.isEmpty || name.isEmpty || email.isEmpty || !genderSelected) {
            errorMessage = "Please fill in all fields!"
            signUpDisabled = false
            return
        }
        
        let emailRegex = /.+@.+\..+/
        if !email.contains(emailRegex) {
            errorMessage = "Invalid email!"
            signUpDisabled = false
            return
        }
        
        let signUpStruct: SignUpStruct = SignUpStruct(username: email, password: password, gender: gender, name: name)
        do {
            let token: String = try SignUpStruct.signUpRequest(signUpData: signUpStruct)
            KeychainHelper.standard.save(Data(token.utf8), service: "access-token", account:"peachSconeMarket")
            loggedIn = true
        } catch HttpError.runtimeError(let message){
            errorMessage = "\(message)"
        } catch {
            errorMessage = "\(error)"
        }
        signUpDisabled = false
        return
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(active: .constant(true), loggedIn: .constant(false))
    }
}
