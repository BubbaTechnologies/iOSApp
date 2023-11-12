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
    var totalPages: Int
    var api: Api
    
    init() {
        self.clothingItems = []
        self.requestType = .none
        self.currentPage = 0
        self.api = Api()
        self.allClothingItemsLoaded = false
        self.totalPages = 0
    }
    
    init(clothingItems: [ClothingItem]) {
        self.clothingItems = clothingItems
        self.requestType = .none
        self.currentPage = 0
        self.api = Api()
        self.allClothingItemsLoaded = false
        self.totalPages = 0
    }
    
    init(api: Api, requestType: CollectionStruct.CollectionRequestType) {
        self.clothingItems = []
        self.requestType = requestType
        self.currentPage = 0
        self.api = api
        self.allClothingItemsLoaded = false
        self.totalPages = 0
    }
    
    func getTotalPages() {
        var value: Int = 0
        
        do {
            value = try self.api.getPageCount(collectionType: self.requestType)
        } catch {
            print("\(error)")
            value = -1
        }
        
        self.totalPages = value
    }
    
    func loadItems() throws -> Void {
        try self.loadNext()
    }
    
    func loadNext() throws -> Void {
        if (self.currentPage >= self.totalPages) {
            self.allClothingItemsLoaded = true
            return
        }
        
        try api.loadClothingPage(collectionType: requestType, pageNumber: self.currentPage) { items in
            //Updates variables on main thread.
            DispatchQueue.main.sync{
                self.clothingItems.append(contentsOf: items)
                self.currentPage += 1
            }
        }
    }
    
    func loadNext(completion: @escaping (Result<Bool,Error>)->Void) -> Void {
        do {
            if (self.currentPage >= self.totalPages) {
                self.allClothingItemsLoaded = true
                completion(.success(true))
                return
            }
            
            try self.api.loadClothingPage(collectionType: self.requestType, pageNumber: self.currentPage) { items in
                self.clothingItems.append(contentsOf: items)
                self.currentPage += 1
                completion(.success(false))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func reset() {
        self.clothingItems.removeAll()
        self.currentPage = 0
    }
}
