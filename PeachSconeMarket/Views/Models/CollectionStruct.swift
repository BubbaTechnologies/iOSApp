//
//  CollectionStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/12/23.
//

import Foundation

struct embeddedStruct: Codable {
    private let _embedded: CollectionStruct
    
    init(_embedded: CollectionStruct) {
        self._embedded = _embedded
    }
    
    func getItems()->[ClothingItem]{
        return self._embedded.getItems()
    }
}

struct CollectionStruct: Codable {
    private let clothingDTOList: [ClothingItem]
    
    init(clothingDTOList: [ClothingItem]) {
        self.clothingDTOList = clothingDTOList
    }
    
    func getItems()->[ClothingItem]{
        return self.clothingDTOList
    }
    
    static func collectionRequest(type:String) throws -> [ClothingItem] {
        let token: String = String(data: KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket")!,encoding: .utf8)!
        let sem = DispatchSemaphore.init(value: 0)
        
        var request:URLRequest
        if type.lowercased() == "likes" {
            request = URLRequest(url: URL(string:"https://api.peachsconemarket.com/app/likes")!)
        } else if type.lowercased() == "collection" {
            request = URLRequest(url: URL(string:"https://api.peachsconemarket.com/app/collection")!)
        } else {
            throw HttpError.runtimeError("Invalid type.")
        }
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Host":"api.peachsconemarket.com",
            "Authorization":"Bearer " + token
        ]
        
        var statusCode:String = ""
        var returnList:[ClothingItem] = []
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer{ sem.signal() }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    statusCode = String(response.statusCode)
                    return
                }
            }
            
            if let data = data {
                let responseData = try! JSONDecoder().decode(embeddedStruct.self, from: data)
                returnList = responseData.getItems()
            }
        }.resume()
        
        sem.wait()
        
        if !statusCode.isEmpty {
            throw HttpError.runtimeError("Connection Error: Status Code " + statusCode)
        }
        
        return returnList
    }
}
