//
//  CollectionStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/12/23.
//

import Foundation

struct embeddedStruct: Codable {
    private let _embedded: CollectionStruct
    
    init(_embedded: CollectionStruct) {
        self._embedded = _embedded
    }
    
    func getItems()->[ClothingItem]{
        return self._embedded.getItems()
    }
    
    func getCollectionStruct()->CollectionStruct {
        return _embedded
    }
}

struct CollectionStruct: Codable {
    private let clothingDTOList: [ClothingItem]
    var collectionRequestType: CollectionRequestType
    
    init(clothingDTOList: [ClothingItem]) {
        self.clothingDTOList = clothingDTOList
        self.collectionRequestType = CollectionRequestType.none
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clothingDTOList = try container.decode([ClothingItem].self, forKey: .clothingDTOList)
        self.collectionRequestType = CollectionRequestType.none
    }
    
    init(clothingDTOList: [ClothingItem], collectionRequestType: CollectionRequestType) {
        self.clothingDTOList = clothingDTOList
        self.collectionRequestType = collectionRequestType
    }
    
    func getItems()->[ClothingItem]{
        return self.clothingDTOList
    }
    
    private enum CodingKeys: String, CodingKey {
        case clothingDTOList = "clothingDTOList"
    }
    
    enum CollectionRequestType:String, Codable {
        case likes = "likes"
        case collection = "collection"
        case cardList = "cardList"
        case none = "none"
    }
}
