//
//  SettingsView.swift
//  Carou
//
//  Created by Matt Groholski on 11/20/23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var api: Api
    @State private var confirmPassword: String = ""
    @State private var genderSelected:Bool = false
    var changeFunction: (PageState)->Void
    @State var updateText: String = "Update"
    
    @State var displayErrorMessage = false
    @State var errorMessage = ""
    
    var body: some View {
        GeometryReader {reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack{
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.028)
                    .padding(.bottom, reader.size.height * 0.01)
                ScrollView{
                    VStack{
                        Text("Account Actions")
                            .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.075, relativeTo: .title3))
                            .foregroundColor(Color("DarkFontColor"))
                        
                        ButtonView(text: updateText, confirmation: false, widthFactor: 0.5, fontFactor: 0.06) {
                            updateText = "Coming Soon!"
                        }
                        .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight * 0.9, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor * 0.9))
                        
                        ButtonView(text: "Logout", confirmation: true, widthFactor: 0.5, fontFactor: 0.06) {
                            KeychainHelper.standard.delete(service: "access-token", account: "peachSconeMarket")
                            exit(0)
                        }
                        .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight * 0.95, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor * 0.95))
                        
                        ButtonView(text: "Delete", confirmation: true, widthFactor: 0.5, fontFactor: 0.06) {
                            do {
                                let responseValue = try api.deleteAccount()
                                if responseValue == false {
                                    errorMessage = "Could not delete account."
                                    displayErrorMessage = true
                                } else {
                                    KeychainHelper.standard.delete(service: "access-token", account: "peachSconeMarket")
                                    exit(0)
                                }
                            } catch {
                                errorMessage = "\(error)"
                                displayErrorMessage = true
                            }
                        }
                        .frame(height: max(LoginSequenceDesignVariables.buttonMinHeight * 0.95, reader.size.height * LoginSequenceDesignVariables.buttonHeightFactor * 0.95))
                    }
                }.frame(width: reader.size.width ,height: reader.size.height * 0.85, alignment: .center)
                NavigationButtonView(showFilter: false, showEdit: false, options: .constant(false), buttonAction: changeFunction)
                    .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                    .padding(.bottom, reader.size.height * NavigationViewDesignVariables.BOTTOM_PADDING_FACTOR)
            }
            .frame(width: reader.size.width, height: reader.size.height)
        }
    }
}





#Preview {
    SettingsView(api: Api(), changeFunction: {_ in return})
}
