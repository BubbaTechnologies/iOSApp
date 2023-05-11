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
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center) {
                Spacer()
                TitleView()
                    .padding(.bottom, 5)
                TextInputView(promptText: "Name", input: $name, secure: false)
                TextInputView(promptText: "Email", input: $email, secure: false)
                TextInputView(promptText: "Password", input: $password, secure: true)
                TextInputView(promptText: "Confirm Password", input: $confirmPassword, secure: true)
                //TODO: Make function for sign up
                ButtonView(text: "Sign Up", action: {()->Void in return})
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
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(active: .constant(true))
    }
}
