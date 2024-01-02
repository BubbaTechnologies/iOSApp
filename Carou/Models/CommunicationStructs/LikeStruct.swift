//
//  LikeStruct.swift
//  Carou
//
//  Created by Matt Groholski on 5/12/23.
//

import Foundation

struct LikeStruct: Codable {
    private let imageTaps: Int
    private let clothingId: Int
    public let likeType: LikeType
    
    
    init (clothingId: Int, imageTaps: Int, likeType: LikeType) {
        self.clothingId = clothingId
        self.imageTaps = imageTaps
        self.likeType = likeType
    }
    
    enum EncodingKeys: String, CodingKey {
        case imageTaps
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
