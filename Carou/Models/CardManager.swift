//
//  CardImageController.swift
//  Carou
//
//  Created by Matt Groholski on 9/15/23.
//

import Foundation

class CardManager: ObservableObject {
    private static let preloadAmount = -1
    
    private let item: ClothingItem
    private let clothingCardPreloadAmount: Int
    var presetIndex: Int
    @Published var cardValues: [(zIndex: Int, imageIndex: Int)]
    
    convenience init(item: ClothingItem) {
        self.init(item: item, presetIndex: 0)
    }
    
    init(item: ClothingItem, presetIndex: Int) {
        self.presetIndex = presetIndex
        self.item = item
        
        if CardManager.preloadAmount > 0 {
            self.clothingCardPreloadAmount = min(item.imageURL.count, CardManager.preloadAmount)
        } else {
            self.clothingCardPreloadAmount = item.imageURL.count
        }
        
        self.cardValues = []
        for i in 0..<clothingCardPreloadAmount {
            self.cardValues.append((((clothingCardPreloadAmount - 1 - i) + self.presetIndex) % clothingCardPreloadAmount, i))
        }
    }
    
    func getItem()->ClothingItem {
        return self.item
    }
    
    func getClothingCardPreloadAmount()->Int {
        return self.clothingCardPreloadAmount
    }
    
    func incrementValues(currentCardIndex: Int){
        let preloadAmount = self.getClothingCardPreloadAmount()
        
        //Updates zIndex and imageIndex
        for i in 0 ..< self.getClothingCardPreloadAmount() {
            let newZIndex = ((self.cardValues[i].zIndex + 1) % preloadAmount)
            var newImageIndex = self.cardValues[i].imageIndex

            if i == currentCardIndex {
                newImageIndex = (self.cardValues[currentCardIndex].imageIndex + self.getClothingCardPreloadAmount()) % self.getItem().imageURL.count
            }
            
            self.cardValues[i] = (newZIndex, newImageIndex)
        }
    }
}
