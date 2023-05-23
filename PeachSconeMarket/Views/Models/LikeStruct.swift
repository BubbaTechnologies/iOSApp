//
//  LikeStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/12/23.
//

import Foundation

struct LikeStruct: Codable {
    private let imageTapRatio: Double
    private let clothingId: Int
    
    init (clothingId: Int, imageTapRatio:Double) {
        self.clothingId = clothingId
        self.imageTapRatio = imageTapRatio
    }
    
    static func createLikeRequest(likeStruct: LikeStruct, likeType: LikeType) throws {
        let token: String = String(data: KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket")!,encoding: .utf8)!
        var request = URLRequest(url: URL(string: "https://api.peachsconemarket.com/app/" + likeType.rawValue)!)
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
    
    enum LikeType: String {
        case like = "like"
        case dislike = "dislike"
        case removeLike = "removeLike"
        case pageClick = "pageClick"
        case bought = "bought"
    }
}
