//
//  ClothingPageManager.swift
//  Carou
//
//  Created by Matt Groholski on 8/24/23.
//

import Foundation

class ClothingPageManager: ObservableObject, ClothingManager {
    @Published var clothingItems: [ClothingItem]
    @Published var allClothingItemsLoaded: Bool

    @Published var attemptedLoad: Bool = false
    
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
    
    func loadItems() -> Void {
        self.loadNext()
    }
    
    /**
     - Description: Provides a non-closure interface to load the next set of clothing.
     */
    func loadNext() -> Void {
        self.loadNext{_ in return}
    }
    
    /**
        - Description: Loads the next page of clothing.
        - Parameters:
                - completion: Function to execute upon load completion.
     */
    func loadNext(completion: @escaping (Result<Bool,Error>)->Void) -> Void {
        do {
            if (attemptedLoad && self.currentPage >= self.totalPages) {
                DispatchQueue.main.sync{
                    self.allClothingItemsLoaded = true
                }
                completion(.success(true))
            } else {
                try self.api.loadClothingPage(collectionType: self.requestType, pageNumber: self.currentPage) { items, pageAmount in
                    self.totalPages = pageAmount
                    if self.totalPages == 0 {
                        completion(.success(true))
                    } else {
                        self.clothingItems.append(contentsOf: items)
                        self.currentPage += 1
                        completion(.success(false))
                    }
                }
            }
        } catch {
            completion(.failure(error))
        }
        
        DispatchQueue.main.sync{
            self.attemptedLoad = true
        }
    }
    
    func reset() {
        self.clothingItems.removeAll()
        self.currentPage = 0
        self.attemptedLoad = false
    }
}
