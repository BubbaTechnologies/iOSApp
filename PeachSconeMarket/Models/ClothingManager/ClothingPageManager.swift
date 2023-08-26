//
//  ClothingPageManager.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 8/24/23.
//

import Foundation

class ClothingPageManager: ObservableObject, ClothingManager {
    @Published var clothingItems: [ClothingItem]
    @Published var allClothingItemsLoaded: Bool
    
    var requestType: CollectionStruct.CollectionRequestType
    var currentPage: Int
    var api: Api
    
    init() {
        self.clothingItems = []
        self.requestType = .none
        self.currentPage = 0
        self.api = Api()
        self.allClothingItemsLoaded = false
    }
    
    init(clothingItems: [ClothingItem]) {
        self.clothingItems = clothingItems
        self.requestType = .none
        self.currentPage = 0
        self.api = Api()
        self.allClothingItemsLoaded = false
    }
    
    init(api: Api, requestType: CollectionStruct.CollectionRequestType) {
        self.clothingItems = []
        self.requestType = requestType
        self.currentPage = 0
        self.api = api
        self.allClothingItemsLoaded = false
    }
    
    func loadItems() throws -> Void {
        try self.loadNext()
    }
    
    func loadNext() throws -> Void {
        try api.loadClothingPage(collectionType: requestType, pageNumber: self.currentPage) { items in
            if items.isEmpty {
                self.allClothingItemsLoaded = true
                return
            }
            
            self.clothingItems.append(contentsOf: items)
            self.currentPage += 1
        }
    }
    
    func loadNext(completion: @escaping (Error?)->Void) -> Void {
        DispatchQueue.main.async{
            do {
                try self.api.loadClothingPage(collectionType: self.requestType, pageNumber: self.currentPage) { items in
                    if items.isEmpty {
                        self.allClothingItemsLoaded = true
                        return
                    }
                    
                    self.clothingItems.append(contentsOf: items)
                    self.currentPage += 1
                    completion(nil)
                }
            } catch {
                completion(error)
            }
        }
    }
    
    func reset() {
        self.clothingItems.removeAll()
        self.currentPage = 0
    }
}
