//
//  VerificationView.swift
//  Carou
//
//  Created by Matt Groholski on 11/20/23.
//

import SwiftUI

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

#Preview {
    VerificationView(verificationCode: .constant(""), viewIsPresent: .constant(true), buttonAction: {})
}
