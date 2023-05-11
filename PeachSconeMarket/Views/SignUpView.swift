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
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center) {
                Spacer()
                TitleView()
                    .padding(.bottom, 5)
                TextInputView(promptText: "Name", input: $name)
                TextInputView(promptText: "Email", input: $email)
                TextInputView(promptText: "Password", input: $password)
                TextInputView(promptText: "Confirm Password", input: $confirmPassword)
                //TODO: Make function for sign up
                ButtonView(text: "Sign Up", action: {()->Void in return})
                Spacer()
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
