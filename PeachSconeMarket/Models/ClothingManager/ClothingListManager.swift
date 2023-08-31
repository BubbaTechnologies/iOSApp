//
//  ClothingListManager.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 8/24/23.
//

import Foundation

class ClothingListManager: ObservableObject, ClothingManager {
    @Published var clothingItems: [ClothingItem]
    var api: Api
    
    init() {
        self.clothingItems = []
        self.api = Api()
    }
    
    init(clothingItems: [ClothingItem]) {
        self.clothingItems = clothingItems
        self.api = Api()
    }
    
    init(api: Api) {
        self.clothingItems = []
        self.api = api
    }
    
    
    func loadItems() throws {
        try api.loadClothingPage(collectionType: .cardList, pageNumber: nil) { items in
            self.clothingItems.append(contentsOf: items)
        }
    }
    
    func loadNext() throws {
        var apiError: Error? = nil
        try api.loadClothing() { result in
            switch result {
            case .success(let item):
                self.clothingItems.append(item)
            case .failure(let error):
                apiError = error
            }
        }
        
        if let apiError = apiError {
            throw apiError
        }
    }
    
    func reset() {
        self.clothingItems = []
    }
}
