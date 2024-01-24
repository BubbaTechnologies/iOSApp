//
//  CollectionStruct.swift
//  Carou
//
//  Created by Matt Groholski on 5/12/23.
//

import Foundation

struct CollectionStruct: Codable {
    private let clothingList: [ClothingItem]
    private let totalPageCount: Int
    
    init() {
        self.clothingList = []
        self.totalPageCount = 0
    }
    
    init(clothingList: [ClothingItem]) {
        self.clothingList = clothingList
        self.totalPageCount = 0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clothingList = try container.decode([ClothingItem].self, forKey: .clothingList)
        self.totalPageCount = try container.decode(Int.self, forKey: .totalPageCount)
    }
    
    init(clothingList: [ClothingItem], totalPageCount: Int) {
        self.clothingList = clothingList
        self.totalPageCount = totalPageCount
    }
    
    func getItems()->[ClothingItem]{
        return self.clothingList
    }
    
    func getTotalPageCount()->Int {
        return self.totalPageCount
    }
    
    private enum CodingKeys: String, CodingKey {
        case clothingList = "clothingList"
        case totalPageCount = "totalPages"
    }
    
    
    enum CollectionRequestType:String, Codable {
        case likes = "likes"
        case collection = "collection"
        case cardList = "cardList"
        case preview = "preview"
        case activity = "profileActivity"
        case none = "none"
    }
}
