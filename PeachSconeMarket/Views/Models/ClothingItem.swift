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
    
    static func loadItem(gender: String, type: [String], completion:@escaping (ClothingItem)->()) {
        var type: [String] = type
        for i in 0..<type.count {
            type[i] = type[i].lowercased().replacingOccurrences(of: " ", with: "_")
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.peachsconemarket.com"
        urlComponents.path = "/app/card"
        
        var urlParameters = [URLQueryItem]()
        if (gender != "") {
            urlParameters.append(URLQueryItem(name: "gender", value: gender))
        }
        
        if (type != []) {
            var filterString:String = ""
            for i in type {
                filterString += i + ","
            }
            urlParameters.append(URLQueryItem(name: "type", value: String(filterString.dropLast())))
        }
        
        urlComponents.queryItems = urlParameters
        getItem(url: urlComponents.url!, completion: completion)
    }
    
    private static func getItem(url: URL, completion:@escaping (ClothingItem)->()) {
        let token: String = String(data: KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket")!,encoding: .utf8)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Authorization":"Bearer " + token,
            "Host":"api.peachsconemarket.com"
        ]
            
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response=response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print(response.statusCode)
                    return
                }
            }
            
            if let data = data {
                let item = try! JSONDecoder().decode(ClothingItem.self, from: data)
                DispatchQueue.main.async {
                    completion(item)
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                return
            }
        }.resume()
    }
}


extension ClothingItem {
    static let sampleItems: [ClothingItem] = [
        ClothingItem(id: 1, name: "Saltwater Slub Pocket Tee", imageURL:["https://cdn.shopify.com/s/files/1/2445/4975/products/1210096_Saltwater_Slub_Pocket_Tee_FDO_1.jpg?v=1678729658","https://cdn.shopify.com/s/files/1/2445/4975/products/FDO_SWT_44a05eca-3021-45d3-92ef-346bc23a079f.png?v=1682451906","https://cdn.shopify.com/s/files/1/2445/4975/files/1210096_Saltwater_Slub_Pocket_Tee_FDO_1.jpg?v=1682451906","https://cdn.shopify.com/s/files/1/2445/4975/products/1210096_Saltwater_Slub_Pocket_Tee_FDO_3.jpg?v=1682451906"], productURL: "https://www.outerknown.com/products/saltwater-slub-pocket-tee-faded-olive"),
        ClothingItem(id:2, name: "GOAT Vintage Upcycled Adidas '80s T-Shirt", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dwc9a7132a/product_images/0702526000029NEW_00_001.jpg?sw=700"], productURL: "https://www.pacsun.com/goat-vintage/upcycled-adidas-80s-t-shirt-0702526000029.html"),
        ClothingItem(id: 3, name: "Holly Asymmetric Straight Leg Jean Green Denim", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw60bf305b/product_images/0870604270003NEW_00_089.jpg?sw=700","https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw30605c47/product_images/0870604270003NEW_02_089.jpg?sw=400"], productURL: "https://www.pacsun.com/ngorder/green-purple-checkerboard-romper-0870604270003.html")
        //NGOrder Green & Purple Checkerboard Romper
    ]
}
