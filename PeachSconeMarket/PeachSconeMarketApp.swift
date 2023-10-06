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
    @ObservedObject var likeStore: LikeStore = LikeStore()
    
    @State var errorMessage: String = ""
    @State var errorPresent: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if appStage == .loading {
                LoadingView()
                    .onAppear{
                        load()
                    }.alert(isPresented: $errorPresent) {
                        Alert(title: Text("The market is not open!"),
                        message: Text("\(errorMessage)"))
                    }
            } else if appStage == .authentication {
                LoginView(api: api, completionFunction: {appStage = .loading})
            } else if appStage == .main {
                MainView(api: self.api, swipeClothingManager: self.swipeClothingManager, store: self.likeStore)
                    .task{
                        do {
                            //Trys to load persisted like data and send it to server
                            try await likeStore.load()
                            
                            while likeStore.likes.count > 0 {
                                let like = likeStore.likes[0]
                                try api.sendLike(likeStruct: like)
                                likeStore.likes.removeFirst()
                            }
                        } catch {
                            print("\(error)")
                        }
                    }
            }
        }
    }
}

extension PeachSconeMarketApp {
    func load() {
        DispatchQueue.global(qos: .userInitiated).async{
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
    }

    
    enum stage {
        case loading
        case authentication
        case main
    }
}

