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
    public let likeType: LikeType
    
    
    init (clothingId: Int, imageTapRatio:Double, likeType: LikeType) {
        self.clothingId = clothingId
        self.imageTapRatio = imageTapRatio
        self.likeType = likeType
    }
    
    enum EncodingKeys: String, CodingKey {
        case imageTapRatio
        case clothingId
    }
    
    enum LikeType: String, Codable {
        case like = "like"
        case dislike = "dislike"
        case removeLike = "removeLike"
        case pageClick = "pageClick"
        case bought = "bought"
    }
}
