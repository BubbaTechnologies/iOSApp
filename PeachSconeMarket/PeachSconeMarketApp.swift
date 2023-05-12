//
//  PeachSconeMarketApp.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/9/23.
//

import SwiftUI

@main
struct PeachSconeMarketApp: App {
    @State var loadingProgress: Double = 0.0
    let preLoadAmount: Int = 20
    @State var items:[ClothingItem] = []
    @State var loggedIn: Bool = (KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket") != nil)
    
    var body: some Scene {
        WindowGroup {
            if loadingProgress == 1 {
                SwipeView(items: $items)
            } else if loggedIn {
                LoadingView(progress: $loadingProgress).task{
                    checkToken()
                    for var i in 1...preLoadAmount {
                        ClothingItem.loadItem() { item in
                            if (!items.contains(item)) {
                                items.append(item)
                                loadingProgress += (Double) (1.0 / Double(preLoadAmount - 2))
                            } else {
                                i -= 1
                            }
                            if (items.count >= (preLoadAmount - 2)) {
                                loadingProgress = 1
                            }
                        }
                    }
                }
            } else {
                LoginView(loggedIn: $loggedIn)
            }
        }
    }
}

extension PeachSconeMarketApp {
    func checkToken() {
        let token: String = String(data: KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket")!,encoding: .utf8)!
        let url = URL(string:"https://api.peachsconemarket.com/app/card")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 403 {
                    //Removes token from keychain
                    loggedIn = false
                }
            }
        }.resume()
    }
}
