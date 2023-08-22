//
//  PeachSconeMarketApp.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

@main
struct PeachSconeMarketApp: App {
    @State var appStage: stage = .loading
    @ObservedObject var api: Api = Api()
    
    @State var errorMessage: String = ""
    @State var errorPresent: Bool = false
    
    
    //Design Variables
    static let fieldMinHeight: CGFloat = 45
    static let fieldHeightFactor = 0.055
    static let buttonMinHeight: CGFloat = 50
    static let buttonHeightFactor = 0.065
    
    var body: some Scene {
        WindowGroup {
            if appStage == .loading {
                LoadingView().onAppear{
                    load()
                }.alert(isPresented: $errorPresent) {
                    Alert(title: Text("No Peaches :("),
                    message: Text("\(errorMessage)"))
                }
            } else if appStage == .authentication {
                LoginView(api: api, appStage: $appStage)
            } else if appStage == .main {
                //TODO: Main Stage
                Text("Congrats you made it!")
            }
        }
    }
}

extension PeachSconeMarketApp {
    func load() {
        do {
            if try api.loadToken() {
                appStage = .main
            } else {
                appStage = .authentication
            }
        } catch Api.ApiError.httpError(let message) {
            errorMessage = message
            errorPresent = true
        } catch {
            errorMessage = "\(error)"
            errorPresent = true
        }
    }

    
    enum stage {
        case loading
        case authentication
        case main
    }
}

