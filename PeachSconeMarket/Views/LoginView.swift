//
//  LoginView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .center){
                Spacer()
                TitleView()
                    .padding(.bottom, 5)
                TextInputView(promptText: "Email", input: $email)
                TextInputView(promptText: "Password", input: $password)
                //TODO: Add sign in function
                ButtonView(text: "Sign In", action: {()->Void in return})
                Spacer()
                //TODO: Add sign in function
                ButtonView(text: "Sign Up", action: {()->Void in return})
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
//        LoginView()
//                    .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
//                    .previewDisplayName("iPhone 14 Pro Max")
    }
}
