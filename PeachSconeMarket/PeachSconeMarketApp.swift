//
//  PeachSconeMarketApp.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

@main
struct PeachSconeMarketApp: App {
<<<<<<< HEAD
    @State var loadingProgress: Double = 0.0
    @State var preLoadAmount: Int = 8
    @State var items:[ClothingItem] = []
    @State var loggedIn: Bool = (KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket") != nil)
    
    var body: some Scene {
        WindowGroup {
            if loadingProgress == 1 {
                MainView(items: $items, preLoadAmount: $preLoadAmount)
            } else if loggedIn {
                LoadingView().task{
                    checkToken()
                    loadingProgress += 0.25
                    do {
                        try ClothingItem.loadItems(gender: "", type: []) { clothingItems in
                            preLoadAmount = clothingItems.count
                            for item in clothingItems {
                                if (!items.contains(item)) {
                                    items.append(item)
                                    loadingProgress += (Double) ((1.0 / Double(preLoadAmount)) * 0.75)
                                }
                                if (items.count >= (preLoadAmount - 2)) {
                                    loadingProgress = 1
                                }
                            }
                        }
                    } catch {
                        exit(0)
                    }
=======
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
>>>>>>> rebuild
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
<<<<<<< HEAD
    func checkToken() {
        let token: String = String(data: KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket")!,encoding: .utf8)!
        let url = URL(string:"https://api.peachsconemarket.com/app/checkToken")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 403 {
                    KeychainHelper.standard.delete(service: "access-token", account: "peachSconeMarket")
                    loggedIn = false
                }
=======
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
>>>>>>> rebuild
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

