//
//  CardImageController.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 9/15/23.
//

import Foundation

class CardController: ObservableObject {
    private static let preloadAmount = 3
    
    private let item: ClothingItem
    private let clothingCardPreloadAmount: Int
    @Published var cardValues: [(zIndex: Int, imageIndex: Int)]
    
    init(item: ClothingItem) {
        self.item = item
        self.clothingCardPreloadAmount = min(item.imageURL.count, CardController.preloadAmount)
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
