//
//  CarouApp.swift
//  Carou
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

@main
struct CarouApp: App {
    @State var appStage: Stage = .loading
    @ObservedObject var swipeClothingManager: ClothingListManager = ClothingListManager()
    @ObservedObject var likeStore: LikeStore = LikeStore()
    @ObservedObject var instanceDataStore: InstanceDataStore = InstanceDataStore()
    @ObservedObject var locationManager: LocationManager = LocationManager()
    @ObservedObject var api: Api = Api()
    @ObservedObject var sessionData: SessionData = SessionData()
    
    @State var errorMessage: String = ""
    @State var errorPresent: Bool = false
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if appStage == .loading {
                LoadingView()
                    .onAppear{
                        load()
                    }.alert(isPresented: $errorPresent) {
                        Alert(title: Text("The market is not open!")
                            .font(CustomFontFactory.getFont(style: "Normal", size: 22, relativeTo: .title))
                            .foregroundColor(Color("DarkFontColor")),
                        message: Text("\(errorMessage)")
                            .font(CustomFontFactory.getFont(style: "Normal", size: 16, relativeTo: .body))
                            .foregroundColor(Color("DarkFontColor")))
                    }
            } else if appStage == .authentication {
                LoginView(api: api, completionFunction: {appStage = .loading})
            } else if appStage == .main {
                MainView(api: self.api, swipeClothingManager: self.swipeClothingManager, store: self.likeStore, instanceDataStore: self.instanceDataStore)
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
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                        sessionData.switchActiveState()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        sessionData.switchActiveState()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in                        
                        do {
                            try api.sendSessionData(sessionData: sessionData)
                            instanceDataStore.save()
                        } catch {
                            print("\(error)")
                        }
                    }
            } else if appStage == .preview {
                PreviewView(swipeClothingManager: swipeClothingManager, likeStore: likeStore, appStage: $appStage)
                    .onAppear{
                        instanceDataStore.displayInstructions = false
                    }
            }
        }
        .environmentObject(self.api)
    }
}

extension CarouApp {
    /**
        - Description: Determines if the user is authenticated. If not, sends the user to the authentication route. If so, loads the token and loads the data for the application.
     */
    func load() {
        //Loading async allows the view to update.
        DispatchQueue.global(qos: .userInitiated).async{
            NotificationManager.shared.requestAuthorization()
            do {
                //Loads browser settings
                self.swipeClothingManager.api = api
                if try api.loadToken() {
                    DispatchQueue.main.sync {
                        self.swipeClothingManager.changeCollectionType(collectionType: .cardList)
                        instanceDataStore.load()
                    }
                    
                    try self.api.loadBrowsing()
                    try self.loadDataAsync()
                    appStage = .main
                } else {
                    DispatchQueue.main.sync{
                        self.swipeClothingManager.changeCollectionType(collectionType: .preview)
                    }
                    let group = DispatchGroup()
                    var returnError: Error? = nil
                    
                    //Loads preview clothing items.
                    group.enter()
                    DispatchQueue.global(qos: .userInitiated).async {
                        do {
                            try self.swipeClothingManager.loadItems()
                        } catch {
                            returnError = error
                        }
                        group.leave()
                    }
                    
                    if returnError != nil {
                        throw returnError!
                    }
                    
                    group.wait()
                    
                    appStage = .preview
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
    
    /**
        - Description: Loads data for the application asynchronously.
        - Throws: Throws an error generated by the API calls.
     */
    func loadDataAsync() throws {
        let group = DispatchGroup()
        var returnError: Error? = nil
        
        //Loads initial clothing items.
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.swipeClothingManager.loadItems()
                try self.api.loadFilterOptions(type: .general)
                try self.api.loadProfile()
            } catch {
                returnError = error
            }
            group.leave()
        }
        
        //Sends location and deviceId data.
        DispatchQueue.global(qos: .background).async{
            do {
                try self.api.updateLocation(latitude: locationManager.region.center.latitude, longitude: locationManager.region.center.longitude)
                try self.api.updateDeviceId(deviceId: NotificationManager.deviceId)
            } catch {
                print("Location Error: \(error)")
            }
        }
        
        group.wait()
        
        if returnError != nil {
            throw returnError!
        }
    }
    
    /**
            - Description: Defines the paths taken from CarouApp.swift
     */
    enum Stage {
        case loading
        case authentication
        case main
        case preview
    }
}



