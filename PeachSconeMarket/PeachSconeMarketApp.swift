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
    @ObservedObject var swipeClothingManager: ClothingListManager = ClothingListManager()
    
    @State var errorMessage: String = ""
    @State var errorPresent: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if appStage == .loading {
                LoadingView().onAppear{
                    load()
                }.alert(isPresented: $errorPresent) {
                    Alert(title: Text("The market is not open!"),
                    message: Text("\(errorMessage)"))
                }
            } else if appStage == .authentication {
                LoginView(api: api, completionFunction: {appStage = .loading})
            } else if appStage == .main {
                MainView(api: api, swipeClothingManager: swipeClothingManager)
            }
        }
    }
}

extension PeachSconeMarketApp {
    func load() {
        do {
            if try api.loadToken() {
                //Loads clothing
                self.swipeClothingManager.api = api
                try self.swipeClothingManager.loadItems()
                try self.api.loadFilterOptions()
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

