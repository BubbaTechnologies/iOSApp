//
//  ClothingListManager.swift
//  Carou
//
//  Created by Matt Groholski on 8/24/23.
//

import Foundation

class ClothingListManager: ObservableObject, ClothingManager {
    @Published var clothingItems: [ClothingItem]
    //List is kept to avoid reloading when new cards are added.
    //Avoids unexpected behavior with images.
    @Published var clothingCardManagers: [CardManager]
    var api: Api
    var collectionType: CollectionStruct.CollectionRequestType = .cardList
    
    init() {
        self.clothingItems = []
        self.api = Api()
        self.clothingCardManagers = []
    }
    
    init(clothingItems: [ClothingItem]) {
        self.clothingItems = clothingItems
        self.api = Api()
        self.clothingCardManagers = []
        
        for item in clothingItems {
            self.clothingCardManagers.append(CardManager(item: item))
        }
    }
    
    init(api: Api) {
        self.clothingItems = []
        self.api = api
        self.clothingCardManagers = []
    }
    
    
    func loadItems() throws {
        try api.loadClothingPage(collectionType: collectionType, pageNumber: nil, userId: nil) { items, _ in
            self.clothingItems.append(contentsOf: items)
            for item in items {
                self.clothingCardManagers.append(CardManager(item: item))
            }
        }
    }
    
    func loadNext() throws {
        var apiError: Error? = nil
        try api.loadClothing() { result in
            switch result {
            case .success(let item):
                self.clothingItems.append(item)
                self.clothingCardManagers.append(CardManager(item: item))
            case .failure(let error):
                apiError = error
            }
        }
        
        if let apiError = apiError {
            throw apiError
        }
    }
    
    func removeFirst() {
        DispatchQueue.main.sync{
            self.clothingItems.removeFirst()
            self.clothingCardManagers.removeFirst()
        }
    }
    
    func reset() {
        self.clothingItems = []
        self.clothingCardManagers = []
    }
    
    func changeCollectionType(collectionType: CollectionStruct.CollectionRequestType)->Void {
        self.collectionType = collectionType
        self.reset()
    }
}
