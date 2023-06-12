//
//  ClothingItemPaginator.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 6/3/23.
//

import Foundation


class ClothingItemPaginator: ObservableObject {
    @Published var currentPage = 0
    @Published var clothingItems: [ClothingItem] = []
    var requestType: CollectionStruct.CollectionRequestType
    var clothingType: [String]
    var gender: String
    
    init(requestType: CollectionStruct.CollectionRequestType, clothingItems: [ClothingItem] = [], clothingType: [String] = [], gender: String = "") {
        self.clothingItems = clothingItems
        self.requestType = requestType
        self.clothingType = clothingType
        self.gender = gender
    }
    
    func loadNextPage()throws -> Bool {
        let items = try CollectionStruct.collectionRequest(type: requestType, clothingType: self.clothingType, gender: self.gender, pageNumber: self.currentPage)
        if items.count == 0 {
            return false
        } else {
            clothingItems.append(contentsOf: items)
        }
        self.currentPage += 1
        return true
    }
    
    func reset(){
        clothingItems.removeAll()
        currentPage = 0
    }
}
