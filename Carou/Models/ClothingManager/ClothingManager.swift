//
//  ClothingManager.swift
//  Carou
//
//  Created by Matt Groholski on 8/24/23.
//

import Foundation


protocol ClothingManager {
    var clothingItems: [ClothingItem] { get set }
    var api: Api { get set }
    
    func loadItems() throws -> Void
    func loadNext() throws -> Void
    func reset()
}
