//
//  CardImageController.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 9/15/23.
//

import Foundation

class CardManager: ObservableObject {
    private static let preloadAmount = -1
    
    private let item: ClothingItem
    private let clothingCardPreloadAmount: Int
    @Published var cardValues: [(zIndex: Int, imageIndex: Int)]
    
    init(item: ClothingItem) {
        self.item = item
        
        if CardManager.preloadAmount > 0 {
            self.clothingCardPreloadAmount = min(item.imageURL.count, CardManager.preloadAmount)
        } else {
            self.clothingCardPreloadAmount = item.imageURL.count
        }
        
        self.cardValues = []
        for i in 0..<clothingCardPreloadAmount {
            self.cardValues.append((clothingCardPreloadAmount - i - 1, i))
        }
    }
    
    func getItem()->ClothingItem {
        return self.item
    }
    
    func getClothingCardPreloadAmount()->Int {
        return self.clothingCardPreloadAmount
    }
}
