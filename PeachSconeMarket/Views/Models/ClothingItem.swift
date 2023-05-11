//
//  ClothingItem.swift
//  Bubba
//
//  Created by Matt Groholski on 11/2/22.
//

import Foundation

struct ClothingItem: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let imageURL: [String]
    let productURL: String
    
    init (id: Int, name: String, imageURL: [String], productURL: String) {
        self.id  = id
        self.name = name
        self.imageURL = imageURL
        self.productURL = productURL
    }
    
    static func loadItem(token:String, completion:@escaping (ClothingItem)->()) {
        let url = URL(string:"https://api.bubba-app.com/app/card")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            
        URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let item = try! JSONDecoder().decode(ClothingItem.self, from: data)
                    DispatchQueue.main.async {
                        completion(item)
                    }
                }
        }.resume()
    }
}


extension ClothingItem {
    static let sampleItems: [ClothingItem] = [
        ClothingItem(id: 1, name: "Another Girl Eco Fur Collar Button Front Mesh Top", imageURL:["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw51f8a7e2/product_images/0712603470006NEW_00_089.jpg?sw=700","https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw37e7274b/product_images/0712603470006NEW_01_089.jpg?sw=700","https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dwbfa65798/product_images/0712603470006NEW_02_089.jpg?sw=700","https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dwa7c7885e/product_images/0712603470006NEW_03_089.jpg?sw=700"], productURL: "https://www.pacsun.com/another-girl/eco-fur-collar-button-front-mesh-top-0712603470006.html"),
        ClothingItem(id:2, name: "GOAT Vintage Upcycled Adidas '80s T-Shirt", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dwc9a7132a/product_images/0702526000029NEW_00_001.jpg?sw=700"], productURL: "https://www.pacsun.com/goat-vintage/upcycled-adidas-80s-t-shirt-0702526000029.html"),
        ClothingItem(id: 3, name: "NGOrder Green & Purple Checkerboard Romper", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw60bf305b/product_images/0870604270003NEW_00_089.jpg?sw=700","https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw30605c47/product_images/0870604270003NEW_02_089.jpg?sw=400"], productURL: "https://www.pacsun.com/ngorder/green-purple-checkerboard-romper-0870604270003.html")
    ]
}
