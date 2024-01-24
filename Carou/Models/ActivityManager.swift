//
//  ClothingActivityManager.swift
//  Carou
//
//  Created by Matt Groholski on 1/16/24.
//

import Foundation

class ActivityManager: ObservableObject {
    @Published var activityItems: [ActivityObject]
    @Published var allItemsLoaded: Bool
    
    @Published var attemptedLoad: Bool = false
    
    var currentPage: Int
    var totalPages: Int
    var api: Api
    
    init() {
        self.activityItems = []
        self.allItemsLoaded = true
        self.attemptedLoad = true
        self.currentPage = 0
        self.totalPages = 0
        self.api = Api()
    }
    
    init(clothingItems: [ClothingItem]) {
        self.activityItems = []
        self.allItemsLoaded = true
        self.attemptedLoad = true
        self.currentPage = 0
        self.totalPages = 0
        self.api = Api()
        
        for item in clothingItems {
            self.activityItems.append(ActivityObject(profile: ActivityProfileStruct(id: 1, username: "Matthew Groholski", privateAccount: false, followingStatus: .following), clothingItem: item))
        }
    }
    
    init (api: Api) {
        self.activityItems = []
        self.allItemsLoaded = false
        self.attemptedLoad = false
        self.currentPage = 0
        self.totalPages = 0
        self.api = api
    }
    
    func loadItems() -> Void {
        self.loadNext()
    }
    
    func loadNext() -> Void {
        self.loadNext{_ in return}
    }
    
    func loadNext(completion: @escaping (Result<Bool,Error>)->Void) -> Void {
        do {
            if (attemptedLoad && self.currentPage >= self.totalPages) {
                DispatchQueue.main.sync{
                    self.allItemsLoaded = true
                }
                completion(.success(true))
            } else {
                try self.api.loadActivityPage(pageNumber: self.currentPage) { items, pageAmount in
                    self.totalPages = pageAmount
                    if self.totalPages == 0 {
                        completion(.success(true))
                    } else {
                        self.activityItems.append(contentsOf: items)
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
        self.activityItems.removeAll()
        self.currentPage = 0
        self.attemptedLoad = false
    }
}

struct ActivityObject: Decodable {
    var profile: ActivityProfileStruct
    var clothingItem: ClothingItem
}
