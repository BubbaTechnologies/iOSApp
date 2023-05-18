//
//  LikeStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/12/23.
//

import Foundation

struct LikeStruct: Codable {
    private let clothingId: String
    private let rating: String
    
    init (clothingId: String, rating: String) {
        self.clothingId = clothingId
        self.rating = rating
    }
    
    static func createLikeRequest(likeStruct: LikeStruct) throws {
        let token: String = String(data: KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket")!,encoding: .utf8)!
        var request = URLRequest(url: URL(string: "https://api.peachsconemarket.com/app/like")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Authorization":"Bearer " + token,
            "Host":"api.peachsconemarket.com",
            "Content-Type":"application/json"
        ]
        
        request.httpBody = try JSONEncoder().encode(likeStruct)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print(response.statusCode)
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                }
            }
        }.resume()
    }
    
    static func updateLikeRequest(likeStruct: LikeStruct) throws {
        let token: String = String(data: KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket")!,encoding: .utf8)!
        var request = URLRequest(url: URL(string: "https://api.peachsconemarket.com/app/like")!)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Authorization":"Bearer " + token,
            "Host":"api.peachsconemarket.com",
            "Content-Type":"application/json"
        ]
        
        request.httpBody = try JSONEncoder().encode(likeStruct)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print(response.statusCode)
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                }
            }
        }.resume()
    }
}
