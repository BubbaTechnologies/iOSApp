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
    
    init(requestType: CollectionStruct.CollectionRequestType, clothingItems: [ClothingItem] = []) {
        self.clothingItems = clothingItems
        self.requestType = requestType
    }
    
    func loadNextPage(api: Api) throws -> Bool {
        var items: [ClothingItem]
        try api.loadClothingPage(collectionType: requestType, pageNumber: self.currentPage) { clothingItems in
            items = clothingItems
        }
        
        if items.count == 0 {
            return false
        }
        
        clothingItems.append(contentsOf: items)
        self.currentPage += 1
        return true
    }
    
    func reset(){
        clothingItems.removeAll()
        currentPage = 0
    }
}
